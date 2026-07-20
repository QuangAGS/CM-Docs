# **EGAL-25.2.0 — PRISMA USAGE DOCTRINE**

## **Hướng dẫn chuẩn sử dụng Prisma cho toàn bộ Business Process**

**Phiên bản:** 1.0.0  
**Ngày:** 25/06/2026  
**Phạm vi:** Backend Node.js \+ Prisma \+ PostgreSQL/Supabase  
**Áp dụng cho:** Toàn bộ Business Process của hệ thống EGAL-25.x

---

# **I. Mục tiêu của tài liệu**

Tài liệu này quy định cách sử dụng Prisma trong hệ thống quản lý dòng họ EGAL-25.x.

Mục tiêu không phải chỉ là “gọi Prisma để CRUD”, mà là bảo đảm mọi thao tác dữ liệu đều:

1. Đúng tenant.  
2. Có kiểm soát phân quyền.  
3. Có transaction khi cần tính nguyên tử.  
4. Có khả năng truy vết xuyên suốt bằng `correlation_id`.  
5. Có Business Process Ledger.  
6. Có Audit Ledger khi dữ liệu nghiệp vụ bị thay đổi.  
7. Có Communication Ledger khi cần gửi thông báo.  
8. Không tạo PrismaClient trùng lặp.  
9. Không làm rò rỉ dữ liệu giữa các tenant.  
10. Không phá vỡ doctrine Soft Delete, Multi-tenant và Ledger.

---

# **II. Kiến trúc Prisma chuẩn**

## **2.1. Chỉ có một PrismaClient gốc**

Hệ thống chỉ được tạo một PrismaClient gốc trong:

```
src/lib/prisma.js
```

Không được tạo PrismaClient mới trong controller, service, repository hoặc module.

Sai:

```javascript
const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();
```

Đúng:

```javascript
const { prisma, basePrisma } = require('../../lib/prisma');
```

Lý do:

* **Tránh mở quá nhiều connection tới PostgreSQL/Supabase.**  
* **Tránh lỗi connection pool.**  
* **Tránh bypass tenant context.**  
* **Tránh hành vi không đồng nhất giữa các service.**  
* **Bảo đảm mọi query đều đi qua doctrine trung tâm.**

---

## **2.2. Ba đối tượng Prisma cần phân biệt**

Hệ thống sử dụng ba cấp độ truy cập dữ liệu:

| Đối tượng | Mục đích |
| ----- | ----- |
| **`prisma`** | Prisma đã được bọc Multi-tenant doctrine. Dùng mặc định. |
| **`basePrisma`** | Prisma gốc. Chỉ dùng trong các tình huống đặc biệt được quy định. |
| **`tx`** | Prisma transaction client, chỉ tồn tại bên trong `$transaction`. |

Ví dụ import:

```javascript
const {
  prisma,
  basePrisma,
  runWithTenantContext,
  runWithSystemContext,
  withTransaction
} = require('../../lib/prisma');
```

---

# **III. Quy tắc sử dụng `prisma`**

## **3.1. `prisma` là lựa chọn mặc định**

Mọi Business Service thông thường phải dùng:

```javascript
const { prisma } = require('../../lib/prisma');
```

Ví dụ:

```javascript
const member = await prisma.members.findUnique({
  where: {
    id: memberId
  }
});
```

**`prisma` có nhiệm vụ:**

* **Tự áp tenant filter nếu model thuộc tenant scope.**  
* **Tự inject `tenant_id` khi create.**  
* **Tự chặn query cross-tenant.**  
* **Tự áp doctrine Soft Delete nếu đã được cấu hình.**  
* **Giảm nguy cơ lập trình viên quên điều kiện `tenant_id`.**

---

## **3.2. Không tự truyền tenant\_id tùy tiện**

Sai:

```javascript
await prisma.members.create({
  data: {
    tenant_id: req.body.tenant_id,
    name: req.body.name
  }
});
```

Đúng:

```javascript
await prisma.members.create({
  data: {
    name: req.body.name
  }
});
```

Tenant phải được lấy từ Tenant Context.

Ví dụ:

```javascript
await runWithTenantContext(
  {
    tenantId: req.user.tenant_id,
    actorId: req.user.id,
    actorType: 'USER'
  },
  async () => {
    await memberService.createMember(payload);
  }
);
```

Nguyên tắc:

**Client không được quyền quyết định tenant\_id.**

---

# **IV. Tenant Context Doctrine**

## **4.1. Tenant Context là gì**

Tenant Context là ngữ cảnh kỹ thuật được giữ xuyên suốt một request.

Ví dụ:

```javascript
{
  tenantId: "tenant-uuid",
  actorId: "user-uuid",
  actorType: "USER",
  correlationId: "request-correlation-uuid"
}
```

Tenant Context phục vụ:

* **Cô lập dữ liệu multi-tenant.**  
* **Tự động gắn actor.**  
* **Tự động gắn correlation ID.**  
* **Bảo đảm audit trail.**  
* **Bảo đảm business logs.**  
* **Bảo đảm notifications thuộc đúng tenant.**

---

## **4.2. Không đọc tenant\_id trực tiếp từ body**

Sai:

```javascript
const tenantId = req.body.tenant_id;
```

Đúng:

```javascript
const tenantId = req.user.tenant_id;
```

Hoặc:

```javascript
const context = getRequestContext();
const tenantId = context.tenantId;
```

---

## **4.3. System Context**

Một số tác vụ không thuộc tenant cụ thể:

* Cron job.  
* Job retry.  
* Migration logic.  
* System notification.  
* System audit.  
* Background worker.  
* Import tool.  
* System administrator thao tác toàn cục.

Khi đó dùng:

```javascript
await runWithSystemContext(
  {
    actorId: SYSTEM_ACTOR_ID,
    actorType: 'SYSTEM',
    correlationId
  },
  async () => {
    // system work
  }
);
```

Không được dùng `basePrisma` chỉ vì không có tenant.

---

# **V. Correlation ID Doctrine**

## **5.1. Mục đích**

`correlation_id` là mã liên kết toàn bộ hoạt động thuộc cùng một Business Flow.

Ví dụ một Admin duyệt hồ sơ onboarding:

```
correlation_id = "3a23d3f0-..."
```

Mã này phải xuất hiện trong:

```
onboarding_cases
business_process_logs
audit_logs
notifications
```

Khi cần điều tra một sự kiện, hệ thống có thể truy ngược toàn bộ:

```
Business Case
→ Business Process Logs
→ Audit Logs
→ Notifications
→ Notification Deliveries
```

---

## **5.2. Correlation ID không phải Primary Key**

Không dùng `correlation_id` làm PK.

Lý do:

* Một process có thể retry.  
* Một process có thể có nhiều attempt.  
* Một request có thể tạo nhiều business logs.  
* Một batch process có thể tác động nhiều entity.  
* Một business flow có thể phát sinh nhiều notification.  
* Một correlation có thể tạo nhiều audit logs.

Thiết kế đúng:

```
business_process_logs.id = physical primary key
business_process_logs.correlation_id = trace key
business_process_logs.attempt_no = retry sequence
```

---

## **5.3. Quy tắc tạo correlation ID**

Correlation ID được tạo một lần tại entry point của Business Flow.

Ví dụ controller:

```javascript
const correlationId = req.correlationId;
```

Hoặc:

```javascript
const correlationId = correlationService.create();
```

Sau đó truyền xuyên suốt:

```javascript
await onboardingService.submitCase({
  caseId,
  correlationId,
  actorId: req.user.id
});
```

Không tạo correlation ID mới ở giữa service.

Sai:

```javascript
await businessLogger.createLog({
  correlation_id: uuidv4()
});
```

Đúng:

```javascript
await businessLogger.createLog({
  correlation_id: correlationId
});
```

---

# **VI. Transaction Doctrine**

## **6.1. Khi nào bắt buộc dùng transaction**

Bắt buộc dùng transaction khi một Business Process thay đổi từ hai bảng nghiệp vụ trở lên.

Ví dụ:

* Approve User.  
* Reject User.  
* Submit Onboarding.  
* Approve Onboarding.  
* Merge Branch.  
* Create Member \+ link User.  
* Fund Transfer.  
* Clan Merge.  
* Role Change.  
* Member Remove.  
* Tenant Activation.

Ví dụ:

```javascript
await prisma.$transaction(async (tx) => {
  await tx.users.update({
    where: { id: userId },
    data: { role: 'USER' }
  });

  await tx.members.update({
    where: { id: memberId },
    data: { status: 'CHINH_THUC' }
  });

  await tx.branches.update({
    where: { id: branchId },
    data: { status: 'MERGED' }
  });

  await tx.onboarding_cases.update({
    where: { id: caseId },
    data: {
      status: 'MERGED',
      merged_at: new Date()
    }
  });
});
```

---

## **6.2. Ledger ghi trong transaction**

Các thay đổi nghiệp vụ chính thức và Business Process Ledger phải nằm trong cùng transaction.

Đúng:

```javascript
await prisma.$transaction(async (tx) => {
  await tx.users.update(...);

  await tx.members.update(...);

  await tx.business_process_logs.create({
    data: {
      correlation_id: correlationId,
      attempt_no: 1,
      process_type: 'ONBOARDING_BRANCH_MERGE',
      actor_type: 'USER',
      actor_id: actorId,
      tenant_id: tenantId,
      process_status: 'SUCCESS',
      metadata: {}
    }
  });
});
```

Nếu transaction rollback:

* User không đổi role.  
* Member không đổi status.  
* Branch không merge.  
* Business log không bị ghi sai.

---

## **6.3. Notification Delivery không bắt buộc nằm trong transaction**

Có hai tầng:

### **Tầng 1 — Notification Record**

Nên tạo notification record trong transaction nếu thông báo là một phần quan trọng của business flow.

```javascript
await tx.notifications.create({
  data: {
    user_id: userId,
    tenant_id: tenantId,
    correlation_id: correlationId,
    event_type: 'ONBOARDING_APPROVED',
    title: 'Hồ sơ đã được phê duyệt',
    content: '...',
    status: 'PENDING'
  }
});
```

### **Tầng 2 — External Delivery**

Gửi Email, Telegram, Zalo, Web Push không nên chạy trong transaction.

Lý do:

* Provider có thể chậm.  
* Provider có thể lỗi.  
* Không nên giữ database transaction quá lâu.  
* Không để lỗi email rollback nghiệp vụ chính.

Luồng đúng:

```
Transaction commit
→ notification record tồn tại
→ background worker đọc notification_deliveries
→ gửi qua provider
→ cập nhật delivery status
```

---

# **VII. Business Process Ledger Doctrine**

## **7.1. Vai trò của business\_process\_logs**

`business_process_logs` trả lời câu hỏi:

Hệ thống đã thực hiện Business Process nào, ai thực hiện, kết quả ra sao, retry bao nhiêu lần và dữ liệu nghiệp vụ nào liên quan?

Không dùng bảng này để thay thế audit log.

Không dùng bảng này để thay thế notification.

---

## **7.2. Khi nào phải ghi Business Process Log**

Bắt buộc ghi log cho:

| Nhóm | Ví dụ |
| ----- | ----- |
| User lifecycle | USER\_REGISTER, USER\_APPROVAL, USER\_REJECTION |
| Security | PASSWORD\_RESET\_REQUESTED, USER\_LOCK, USER\_BAN |
| Membership | MEMBER\_ADD, MEMBER\_REMOVE |
| Onboarding | ONBOARDING\_CASE\_CREATE, ONBOARDING\_SUBMIT, ONBOARDING\_APPROVE |
| Clan | CLAN\_CREATE, CLAN\_JOIN |
| Financial | FUND\_TRANSFER |
| Tree operation | BRANCH\_MERGE, MEMBER\_REPARENT |
| Administrative | ROLE\_CHANGED, TENANT\_ACTIVATED |

---

## **7.3. Metadata chuẩn**

Metadata phải có cấu trúc:

```javascript
{
  context: {
    target_id: "uuid",
    target_name: "snapshot name"
  },
  payload: {
    // data specific to process type
  }
}
```

`target_name` là snapshot lịch sử.

Không join realtime để hiển thị lại tên cũ.

Ví dụ:

```javascript
metadata: {
  context: {
    target_id: memberId,
    target_name: "Nguyễn Văn A"
  },
  payload: {
    branch_id: branchId,
    before_status: "DU_BI",
    after_status: "CHINH_THUC"
  }
}
```

---

## **7.4. Không ghi dữ liệu nhạy cảm**

Không được ghi vào metadata:

* Password.  
* Password hash.  
* OTP.  
* Reset token.  
* Access token.  
* Refresh token.  
* Full identity document.  
* Sensitive personal information không cần thiết.  
* Raw request headers.  
* Full authentication payload.

---

# **VIII. Audit Ledger Doctrine**

## **8.1. Vai trò của audit\_logs**

`audit_logs` trả lời câu hỏi:

Dữ liệu nào đã thay đổi, trước và sau thay đổi là gì, ai thay đổi và thay đổi vì lý do gì?

Ví dụ:

```
table_name = users
record_id = user-uuid
action = UPDATE
old_data = { role: "VIEWER" }
new_data = { role: "USER" }
correlation_id = onboarding-correlation-id
```

---

## **8.2. Phân biệt Business Log và Audit Log**

| Nội dung | business\_process\_logs | audit\_logs |
| ----- | ----- | ----- |
| Mục tiêu | Theo dõi process | Theo dõi data mutation |
| Ví dụ | ONBOARDING\_APPROVE | users.role VIEWER → USER |
| Retry | Có attempt\_no | Không cần |
| Snapshot context | Có | Có old/new data |
| UI | Timeline nghiệp vụ | Audit/forensic |
| Correlation ID | Bắt buộc | Nên có |

Một Business Process có thể tạo nhiều Audit Log.

Ví dụ `ONBOARDING_BRANCH_MERGE` có thể tạo audit logs cho:

```
onboarding_cases
branches
members
users
```

---

# **IX. Communication Ledger Doctrine**

## **9.1. Notification tables là Communication Ledger**

Không cần tạo bảng `communication_events` riêng.

Ba bảng sau đã tạo thành Communication Ledger:

```
notifications
notification_recipients
notification_deliveries
```

Ý nghĩa:

| Bảng | Vai trò |
| ----- | ----- |
| notificatios | Nội dung/sự kiện thông báo |
| notification\_recipients | Người nhận |
| notification\_deliveries | Lịch sử gửi theo từng kênh |

---

## **9.2. notifications phải có correlation\_id**

`notifications.correlation_id` là bắt buộc đối với thông báo phát sinh từ Business Process.

Ví dụ:

```javascript
await tx.notifications.create({
  data: {
    user_id: userId,
    tenant_id: tenantId,
    correlation_id: correlationId,
    event_type: 'ONBOARDING_APPROVED',
    title: 'Hồ sơ onboarding đã được phê duyệt',
    content: '...',
    level: 'INFO',
    status: 'PENDING'
  }
});
```

---

## **9.3. tenant\_id trong notifications**

Khuyến nghị có:

```
tenant_id String? @db.VarChar(36)
```

Lý do:

* Hỗ trợ query theo tenant.  
* Hỗ trợ dashboard quản trị.  
* Hỗ trợ RLS.  
* Hỗ trợ notification broadcast theo dòng họ.  
* Hỗ trợ điều tra cross-ledger.  
* Không phải join users chỉ để biết notification thuộc tenant nào.

Tenant ID có thể null với thông báo hệ thống toàn cục.

---

# **X. Quy tắc dùng basePrisma**

## **10.1. basePrisma bị hạn chế**

`basePrisma` không phải lựa chọn mặc định.

**Chỉ dùng khi:**

1. **Bootstrap system.**  
2. **Tenant resolution trước khi tenant context tồn tại.**  
3. **System administrator query toàn cục.**  
4. **Worker xử lý cross-tenant có kiểm soát.**  
5. **Migration support.**  
6. **Health check.**  
7. **Background job đặc biệt.**

Ví dụ:

```javascript
const tenant = await basePrisma.tenants.findUnique({
  where: {
    slug
  }
});
```

Sau khi xác định tenant:

```javascript
await runWithTenantContext(
  {
    tenantId: tenant.id,
    actorId: user.id,
    actorType: 'USER',
    correlationId
  },
  async () => {
    // use prisma here
  }
);
```

---

## **10.2. Không dùng basePrisma trong Business Service thông thường**

Sai:

```javascript
const { basePrisma } = require('../../lib/prisma');

await basePrisma.members.findMany();
```

Vì có thể:

* Bypass tenant filter.  
* Lộ dữ liệu tenant khác.  
* Bypass soft delete.  
* Bypass doctrine audit.  
* Tạo lỗi bảo mật nghiêm trọng.

---

# **XI. Mẫu Business Process chuẩn**

## **11.1. Cấu trúc Service**

```
Controller
→ Request Context
→ Business Service
→ Transaction
→ Domain mutation
→ Business Process Log
→ Audit Log
→ Notification record
→ Background delivery
```

---

## **11.2. Ví dụ Approve User**

```javascript
async function approveUser({
  userId,
  actorId,
  tenantId,
  correlationId,
  note
}) {
  return prisma.$transaction(async (tx) => {
    const user = await tx.users.findUnique({
      where: { id: userId }
    });

    if (!user) {
      throw new Error('USER_NOT_FOUND');
    }

    if (user.status !== 'CHO_DUYET') {
      throw new Error('USER_NOT_PENDING_APPROVAL');
    }

    const updatedUser = await tx.users.update({
      where: { id: userId },
      data: {
        status: 'DA_DUYET',
        role: 'VIEWER',
        changed_by: actorId
      }
    });

    await tx.business_process_logs.create({
      data: {
        correlation_id: correlationId,
        attempt_no: 1,
        process_type: 'USER_APPROVAL',
        actor_type: 'USER',
        actor_id: actorId,
        tenant_id: tenantId,
        process_status: 'SUCCESS',
        metadata: {
          context: {
            target_id: user.id,
            target_name: user.name
          },
          payload: {
            approver_note: note || 'Phê duyệt tài khoản thành công',
            before_status: 'CHO_DUYET',
            after_status: 'DA_DUYET',
            assigned_role: 'VIEWER'
          }
        }
      }
    });

    await tx.audit_logs.create({
      data: {
        table_name: 'users',
        record_id: user.id,
        action: 'UPDATE',
        tenant_id: tenantId,
        changed_by: actorId,
        correlation_id: correlationId,
        change_reason: 'USER_APPROVAL',
        old_data: {
          status: user.status,
          role: user.role
        },
        new_data: {
          status: updatedUser.status,
          role: updatedUser.role
        }
      }
    });

    await tx.notifications.create({
      data: {
        user_id: user.id,
        tenant_id: tenantId,
        correlation_id: correlationId,
        event_type: 'USER_APPROVED',
        title: 'Tài khoản đã được phê duyệt',
        content: 'Tài khoản của bạn đã được phê duyệt.',
        level: 'INFO',
        status: 'PENDING',
        metadata: {
          source_process: 'USER_APPROVAL'
        }
      }
    });

    return updatedUser;
  });
}
```

---

# **XII. Retry Doctrine**

## **12.1. Retry không tạo correlation\_id mới**

Một retry phải giữ nguyên:

```
correlation_id
```

Nhưng tăng:

```
attempt_no
```

Ví dụ:

| correlation\_id | attempt\_no | status |
| ----- | ----- | ----- |
| CORR-100 | 1 | FAILED |
| CORR-100 | 2 | SUCCESS |

---

## **12.2. Retry phải idempotent**

Một retry không được tạo dữ liệu trùng.

Ví dụ sai:

```javascript
await tx.members.create({
  data: memberData
});
```

Ví dụ đúng:

```javascript
await tx.members.upsert({
  where: {
    id: memberId
  },
  create: memberData,
  update: {}
});
```

Hoặc kiểm tra trạng thái trước:

```javascript
if (case.status === 'MERGED') {
  return case;
}
```

---

# **XIII. Quy tắc Soft Delete**

Không dùng delete vật lý với dữ liệu nghiệp vụ quan trọng.

Sai:

```javascript
await prisma.members.delete({
  where: { id: memberId }
});
```

Đúng:

```javascript
await prisma.members.update({
  where: { id: memberId },
  data: {
    deleted_at: new Date(),
    changed_by: actorId
  }
});
```

Các bảng không được xóa vật lý trong vận hành bình thường:

```
users
members
branches
onboarding_cases
business_process_logs
audit_logs
notifications
notification_deliveries
```

---

# **XIV. Quy tắc về trạng thái**

Không dùng một bảng để quản lý toàn bộ workflow.

| Bảng | Vai trò trạng thái |
| ----- | ----- |
| users.status | An ninh tài khoản |
| members.status | Trạng thái gia phả |
| branches.status | Trạng thái nhánh |
| onboarding\_cases.status | Workflow onboarding |
| notifications.status | Trạng thái notification |
| notification\_deliveries.status | Trạng thái gửi theo kênh |
| business\_process\_logs.process\_status | Kết quả process |

Ví dụ:

```
users.status = DA_DUYET
members.status = DU_BI
branches.status = UNDER_REVIEW
onboarding_cases.status = UNDER_REVIEW
```

Các trạng thái này không mâu thuẫn; chúng mô tả các lớp khác nhau.

---

# **XV. Checklist bắt buộc trước khi merge code**

Mỗi Business Process mới phải trả lời:

## **Business Context**

* Process type là gì?  
* Actor là ai?  
* Tenant là gì?  
* Correlation ID lấy từ đâu?  
* Có retry không?  
* Có cần idempotency không?

## **Database**

* Có thay đổi nhiều bảng không?  
* Có cần transaction không?  
* Có cần row lock không?  
* Có soft delete không?  
* Có cần index mới không?

## **Ledger**

* Có Business Process Log không?  
* Có Audit Log không?  
* Có Notification không?  
* Notification có correlation\_id không?  
* Notification có tenant\_id không?

## **Security**

* Có tenant isolation không?  
* Có authorization không?  
* Có state guard không?  
* Có thể bypass bằng API không?  
* Có dữ liệu nhạy cảm trong metadata không?

---

# **XVI. Kết luận**

Prisma trong EGAL-25.x không chỉ là ORM.

Prisma là lớp thực thi doctrine dữ liệu của hệ thống:

```
Multi-tenant isolation
+ Transaction integrity
+ Correlation traceability
+ Business Process Ledger
+ Audit Ledger
+ Communication Ledger
+ Soft Delete
+ Authorization guard
```

Mọi Business Process mới phải được xây dựng theo mô hình:

```
Context
→ Authorization
→ Transaction
→ Domain mutation
→ Business Process Log
→ Audit Log
→ Notification record
→ Async delivery
```

Không được viết Business Process theo kiểu:

```
Controller
→ Prisma CRUD trực tiếp
→ Response
```

vì cách này sẽ làm mất traceability, auditability, retry safety và tenant isolation.

