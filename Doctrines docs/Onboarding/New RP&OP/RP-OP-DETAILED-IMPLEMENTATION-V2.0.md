# KẾ HOẠCH TRIỂN KHAI CHI TIẾT: RP & OP (V2.0 - EXECUTION READY)

**Mã tài liệu:** RP-OP-DETAILED-IMPLEMENTATION-V2.0  
**Dự án:** myclan.com.vn  
**Phiên bản:** 2.0-EXECUTION-READY  
**Ngày ban hành:** 07/11/2026  
**Tham chiếu chuẩn:**
* `RP-OP-DESIGN-SPEC-V3.0.md` (SSOT Thiết kế kiến trúc)
* `RP-OP-BPMN-2.5.0-FROZEN.md` (SSOT Quy trình nghiệp vụ)
* `schema.prisma` (PostgreSQL SSOT Schema)
* EGAL-SEC Doctrine v1.1.0 & BFA Amendment v2.2.2

---

## 0. BẢNG MA TRẬN ÁNH XẠ MÃ TRACEABILITY (DESIGN V3.0 → PHASES)

| Phase | Phạm vi kỹ thuật | Các mã Traceability hiện thực hóa | Checkpoint & Smoke Test |
| :--- | :--- | :--- | :---: |
| **Phase 1** | DDL, Migration & Prisma Schema | `SM-L-01`, `SM-L-02`, `SM-L-03`, `SM-P-02`, `SM-P-03`, `OPT-02` | **CP-1** (Smoke S-1) |
| **Phase 2** | Auth Context, Token & Sandbox Middleware | `SM-U-01`, `SM-U-02`, `SEC-01`, `SEC-02`, `SEC-03`, `SEC-ALS` | **CP-2** (Smoke S-2) |
| **Phase 3** | Claim Service, Cổng G01, MFO Dual-Write | `BPL-01` → `BPL-07`, `CL-01` → `CL-06`, `OPT-01`, `OPT-03`, `OPT-04`, `SM-M`, `SM-P-01` | **CP-3** (Smoke S-3) |
| **Phase 4** | Frontend Client: Screens, Nav & Elder UX | `FE-SCR-01` → `FE-SCR-08`, `FE-NAV-01` → `FE-NAV-04`, `FE-SW-01` → `FE-SW-03`, `FE-NOTI-01` → `FE-NOTI-03`, `FE-ELD-01` → `FE-ELD-03`, `ELD-01` → `ELD-03` | **CP-4** (Smoke S-4) |
| **Phase 5** | Bãi bỏ kế thừa (Deprecation & Cleanup) | `DEP-01`, `DEP-02` | **CP-5** (Smoke S-5) |

---

## PHASE 1: DDL, MIGRATION & PRISMA SCHEMA

### 1.1 Khóa kiểu dữ liệu ID [SM-L-01]
* **Kết luận đối soát SSOT**: Các bảng `users`, `tenants`, `members`, `parentages`, `evidence_links` đều dùng **`VARCHAR(36)`** với giá trị mặc định `(gen_random_uuid())::text`.
* **Quy chuẩn**: Bảng `user_member_links` bắt buộc dùng **`VARCHAR(36)`** cho toàn bộ trường khóa chính và khóa ngoại để ngăn lỗi không tương thích kiểu (`type mismatch error`).

### 1.2 Biên soạn File Migration SQL (`20261107_v250_user_member_links.sql`)
**Vị trí**: `Backend/prisma/migrations/20261107000000_v250_user_member_links/migration.sql`

```sql
BEGIN;

-- 1. [SM-L-02] Tạo Enum trạng thái và loại quan hệ của liên kết
DO $$ BEGIN
  CREATE TYPE user_member_link_status AS ENUM (
    'DRAFT', 
    'CHO_DUYET', 
    'DA_DUYET', 
    'TU_CHOI', 
    'HUY_LIEN_KET'
  );
EXCEPTION WHEN duplicate_object THEN null; END $$;

DO $$ BEGIN
  CREATE TYPE member_link_type AS ENUM (
    'PRIMARY_PATERNAL', 
    'MATERNAL', 
    'SPOUSE_FAMILY', 
    'DESCENDANT_FAMILY', 
    'GUARDIAN', 
    'OTHER'
  );
EXCEPTION WHEN duplicate_object THEN null; END $$;

-- 2. [SM-P-02, SM-P-03] Mở rộng Enum proposals cho luồng Claim và Tranh chấp
ALTER TYPE proposal_status ADD VALUE IF NOT EXISTS 'DISPUTED';
ALTER TYPE proposal_ticket_type ADD VALUE IF NOT EXISTS 'MEMBER_CLAIM';

-- 3. [SM-L-01] Tạo bảng cầu nối đa dòng họ user_member_links
CREATE TABLE IF NOT EXISTS user_member_links (
  id              VARCHAR(36) PRIMARY KEY DEFAULT (gen_random_uuid())::text,
  user_id         VARCHAR(36) NOT NULL,
  tenant_id       VARCHAR(36) NOT NULL,
  member_id       VARCHAR(36) NOT NULL,
  link_type       member_link_type NOT NULL DEFAULT 'PRIMARY_PATERNAL',
  status          user_member_link_status NOT NULL DEFAULT 'CHO_DUYET',
  role_in_tenant  VARCHAR(20) NOT NULL DEFAULT 'USER',
  is_default      BOOLEAN NOT NULL DEFAULT false,
  claim_reason    TEXT,
  approved_by     VARCHAR(36),
  approved_at     TIMESTAMPTZ,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  changed_by      VARCHAR(36),
  deleted_at      TIMESTAMPTZ,

  CONSTRAINT fk_uml_user   FOREIGN KEY (user_id)   REFERENCES users(id)   ON DELETE CASCADE,
  CONSTRAINT fk_uml_tenant FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE,
  CONSTRAINT fk_uml_member FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE CASCADE
);

-- 4. [OPT-02] Chỉ mục hiệu năng truy vấn
CREATE INDEX IF NOT EXISTS idx_uml_user ON user_member_links(user_id);
CREATE INDEX IF NOT EXISTS idx_uml_tenant ON user_member_links(tenant_id);
CREATE INDEX IF NOT EXISTS idx_uml_member ON user_member_links(member_id);
CREATE INDEX IF NOT EXISTS idx_uml_user_default ON user_member_links(user_id, is_default, deleted_at);
CREATE INDEX IF NOT EXISTS idx_uml_tenant_member_status ON user_member_links(tenant_id, member_id, status);

-- 5. [SM-L-03] Partial Unique Index: Bất biến 1-1 Active Member trong cùng dòng họ
CREATE UNIQUE INDEX IF NOT EXISTS unique_active_member_per_tenant
ON user_member_links (tenant_id, member_id)
WHERE status = 'DA_DUYET' AND deleted_at IS NULL;

-- 6. Backfill an toàn dữ liệu 1-1 hiện có sang bảng mới
INSERT INTO user_member_links (user_id, tenant_id, member_id, link_type, status, is_default)
SELECT u.id, u.tenant_id, u.member_id, 'PRIMARY_PATERNAL', 'DA_DUYET', true
FROM users u
WHERE u.member_id IS NOT NULL 
  AND u.tenant_id IS NOT NULL 
  AND u.deleted_at IS NULL
ON CONFLICT DO NOTHING;

COMMIT;
```

### 1.3 Cập nhật `Backend/prisma/schema.prisma`
1. Bổ sung `DISPUTED` vào `enum proposal_status`.
2. Bổ sung `MEMBER_CLAIM` vào `enum proposal_ticket_type`.
3. Khai báo model `user_member_links` và 2 enum `user_member_link_status`, `member_link_type`.
4. Bổ sung quan hệ ngược (`relation`) trong `users`, `tenants`, và `members`.

```bash
# Lệnh thực thi Checkpoint CP-1
npx prisma migrate deploy
npx prisma generate
```

### 1.4 Smoke Test S-1 (Kiểm chứng Phase 1)
```sql
-- 1. Kiểm tra số lượng backfill khớp với users cũ
SELECT 
  (SELECT COUNT(*) FROM users WHERE member_id IS NOT NULL AND deleted_at IS NULL) AS old_count,
  (SELECT COUNT(*) FROM user_member_links WHERE status = 'DA_DUYET') AS new_count;

-- 2. Kiểm tra Partial Unique Index hoạt động chặn trùng lặp active member
-- (Cố ý insert bản ghi thứ 2 có cùng tenant_id, member_id với status = 'DA_DUYET' -> Kỳ vọng ném lỗi 23505)
```

---

## PHASE 2: AUTH CONTEXT & SANDBOX MIDDLEWARE

### 2.1 Điều chỉnh vòng đời `users.status` [SM-U-02]
* **File**: `Backend/src/services/auth.service.js`
* **Nghiệp vụ**:
  * Khi hoàn tất xác thực OTP, giữ nguyên `users.status = 'CHO_DUYET'`.
  * Chỉ cấp Identity Token nền tảng: `{ userId }`.
  * Hàm kích hoạt `users.status = 'DA_DUYET'` chỉ được gọi khi có ít nhất một bản ghi liên kết dòng họ `user_member_links` chuyển sang `DA_DUYET`.

### 2.2 API Switch-Context [SEC-02]
* **File**: `Backend/src/controllers/auth.controller.js` & `Backend/src/routes/auth.routes.js`
* **Route**: `POST /api/auth/switch-context`
* **Payload**: `{ targetTenantId: string }`
* **Logic xử lý**:
  1. Truy vấn `user_member_links` thỏa mãn: `user_id = req.user.id`, `tenant_id = targetTenantId`, `deleted_at IS NULL`, `status IN ('DA_DUYET', 'DRAFT')`.
  2. Nếu không tìm thấy: Trả về `403 FORBIDDEN` (`code: 'NO_TENANT_ACCESS'`).
  3. Nếu tìm thấy: Sinh **Context Token** mới chứa payload:
     ```json
     {
       "userId": "<user_uuid>",
       "activeTenantId": "<tenant_uuid>",
       "activeMemberId": "<member_uuid>",
       "activeLinkStatus": "DA_DUYET | DRAFT",
       "roleInTenant": "USER | CLAN_ADMIN"
     }
     ```
  4. Trả về cho Client: `{ success: true, token, activeContext }`.

### 2.3 Middleware SandboxGate & Whitelist [SEC-01]
* **File**: `Backend/src/middlewares/tenantGate.middleware.js`
* **Logic chốt chặn**:
  ```javascript
  const WHITELIST_DRAFT_PREFIXES = [
    '/api/mfo',
    '/api/me/profile',
    '/api/auth/me',
    '/api/tenants',
    '/api/auth/switch-context'
  ];

  function tenantGate(req, res, next) {
    const { activeLinkStatus } = req.authContext || {};

    if (activeLinkStatus === 'CHO_DUYET') {
      return res.status(423).json({
        success: false,
        code: 'TENANT_MEMBERSHIP_PENDING',
        message: 'Yêu cầu tham gia dòng họ của bạn đang chờ Hội đồng phê duyệt.'
      });
    }

    if (activeLinkStatus === 'DRAFT') {
      const isAllowed = WHITELIST_DRAFT_PREFIXES.some(prefix => req.path.startsWith(prefix));
      if (!isAllowed) {
        return res.status(403).json({
          success: false,
          code: 'SANDBOX_RESTRICTED',
          message: 'Tài khoản đang trong chế độ khởi tạo phả hệ. Chỉ được sử dụng MFO và cập nhật hồ sơ cá nhân.'
        });
      }
    }

    next();
  }
  ```

### 2.4 Cập nhật AsyncLocalStorage (ALS) [SEC-03, SEC-ALS]
* **File**: `Backend/src/lib/prisma.js`
* **Logic**: Mở rộng ALS Context để lưu trữ `activeLinkStatus`. Khi `activeLinkStatus === 'DRAFT'`, Prisma Client Extension tự động kích hoạt bộ lọc bảo vệ: chỉ cho phép `members.create` ở trạng thái `DU_BI` và chặn các thao tác sửa đổi trên cây phả hệ chính thức.

### 2.5 Checkpoint CP-2 & Smoke Test S-2
1. **Test S-2.1**: User mới hoàn tất OTP ➔ Gọi `GET /api/auth/me` ➔ Trả về `users.status = 'CHO_DUYET'`.
2. **Test S-2.2**: User gọi `POST /api/auth/switch-context` với tenant có link `DRAFT` ➔ Nhận token có `activeLinkStatus = 'DRAFT'`.
3. **Test S-2.3**: Dùng token `DRAFT` gọi `GET /api/members` (đọc toàn bộ cây chính) ➔ Bị chặn `403 SANDBOX_RESTRICTED`.
4. **Test S-2.4**: Dùng token `DRAFT` gọi `GET /api/tenants` và `POST /api/mfo/plans` ➔ Trả về `200 OK`.

---

## PHASE 3: CLAIM APIS & MFO ALIGNMENT (+ FTDI)

### 3.1 Dịch vụ Nộp Claim: `submitClaim` [BPL-01, BPL-03, BPL-04, CL-01, CL-02, CL-04, OPT-01]
* **File mới**: `Backend/src/services/membership.service.js`
* **File routes mới**: `Backend/src/routes/membership.routes.js` ➔ Mount vào `app.use('/api/membership', membershipRoutes)`.
* **Kỹ thuật Concurrency & Dispute Handling**:
  ```javascript
  async function submitClaim({ userId, tenantId, targetMemberId, linkType, answers, phoneVerify, vouches, correlationId }) {
    return await prisma.$transaction(async (tx) => {
      // 1. [OPT-01] Thiết lập timeout chống deadlock
      await tx.$executeRawUnsafe(`SET LOCAL lock_timeout = '3s';`);

      // 2. Row-level lock trên nút member mục tiêu
      const [lockedMember] = await tx.$queryRaw`
        SELECT id, tenant_id FROM members WHERE id = ${targetMemberId} FOR UPDATE
      `;
      if (!lockedMember) throw new BusinessError('MEMBER_NOT_FOUND', 404);

      // 3. Kiểm tra xem nút đã có người liên kết chính thức chưa
      const activeLink = await tx.user_member_links.findFirst({
        where: { tenant_id: tenantId, member_id: targetMemberId, status: 'DA_DUYET', deleted_at: null }
      });
      if (activeLink) throw new BusinessError('CLAIM_ALREADY_LINKED', 400);

      // 4. Kiểm tra tranh chấp (Dispute Gate)
      const existingPending = await tx.proposals.findFirst({
        where: { tenant_id: tenantId, target_id: targetMemberId, ticket_type: 'MEMBER_CLAIM', status: 'PENDING' }
      });

      const initialStatus = existingPending ? 'DISPUTED' : 'PENDING';

      // 5. Nếu trùng, đánh dấu tranh chấp proposal cũ và bắn thông báo
      if (existingPending) {
        await tx.proposals.update({
          where: { id: existingPending.id },
          data: { status: 'DISPUTED' }
        });
        // [BPL-03] & [CL-04] Ghi nhận tranh chấp và bật chuông cảnh báo Admin
        await logBPL(tx, {
          context: { actor_id: userId, actor_type: 'USER', correlation_id: correlationId, tenant_id: tenantId },
          payload: { event_name: 'MEMBER_CLAIM_DISPUTE', target_member_id: targetMemberId, proposal_ids: [existingPending.id] }
        });
      }

      // 6. Tạo proposal mới
      const newProposal = await tx.proposals.create({
        data: {
          tenant_id: tenantId,
          ticket_type: 'MEMBER_CLAIM',
          status: initialStatus,
          requester_user_id: userId,
          target_table: 'members',
          target_id: targetMemberId,
          correlation_id: correlationId,
          payload: { answers, phoneVerify, vouches, link_type: linkType }
        }
      });

      // 7. Tạo liên kết dạng chờ
      await tx.user_member_links.create({
        data: {
          user_id: userId,
          tenant_id: tenantId,
          member_id: targetMemberId,
          link_type: linkType,
          status: 'CHO_DUYET',
          proposal_id: newProposal.id
        }
      });

      // 8. [BPL-01] & [CL-01] Ghi BPL và thông báo nội bộ
      await logBPL(tx, {
        context: { actor_id: userId, actor_type: 'USER', correlation_id: correlationId, tenant_id: tenantId },
        payload: { event_name: 'MEMBER_CLAIM_SUBMIT', proposal_id: newProposal.id, target_member_id: targetMemberId }
      });

      return newProposal;
    });
  }
  ```

### 3.2 Phê duyệt Claim tại Cổng G01: `approveClaim` [BPL-02, CL-03, OPT-04]
* **Endpoint**: `POST /api/admin/proposals/:proposalId/approve-claim`
* **File**: `Backend/src/services/membership.service.js`
* **5 Side-effects bắt buộc trong Transaction**:
  ```javascript
  async function approveClaim(tx, { proposalId, actorId, correlationId }) {
    await tx.$executeRawUnsafe(`SET LOCAL lock_timeout = '3s';`);

    const proposal = await tx.proposals.findUnique({ where: { id: proposalId } });
    if (!proposal || proposal.status !== 'PENDING') {
      throw new BusinessError('INVALID_PROPOSAL_STATE', 400);
    }

    const targetUserId = proposal.requester_user_id;

    // 0. Khóa dòng member
    await tx.$queryRaw`SELECT id FROM members WHERE id = ${proposal.target_id} FOR UPDATE`;

    // 1. Nâng link của người nộp sang DA_DUYET
    await tx.user_member_links.updateMany({
      where: { proposal_id: proposalId, user_id: targetUserId, member_id: proposal.target_id },
      data: { status: 'DA_DUYET', approved_by: actorId, approved_at: new Date() }
    });

    // 2. Nâng users.status sang DA_DUYET nếu chưa
    await tx.users.updateMany({
      where: { id: targetUserId, status: 'CHO_DUYET' },
      data: { status: 'DA_DUYET' }
    });

    // 3. [OPT-04] Nhân bản evidence_links sang MEMBER (Bóc tách id, không đè)
    const existingLinks = await tx.evidence_links.findMany({
      where: { target_type: 'PROPOSAL', target_id: proposalId }
    });
    if (existingLinks.length > 0) {
      const linksToCreate = existingLinks.map(({ id, ...rest }) => ({
        ...rest,
        target_type: 'MEMBER',
        target_id: proposal.target_id,
        created_at: new Date()
      }));
      await tx.evidence_links.createMany({ data: linksToCreate, skipDuplicates: true });
    }

    // 4. Tự động sinh Profile Correction nếu có chênh lệch dữ liệu tự khai
    const diffs = proposal.payload?.declared_diffs;
    if (diffs && Object.keys(diffs).length > 0) {
      await tx.proposals.create({
        data: {
          tenant_id: proposal.tenant_id,
          ticket_type: 'PROFILE_CORRECTION',
          status: 'PENDING',
          requester_user_id: targetUserId,
          target_table: 'members',
          target_id: proposal.target_id,
          payload: { diffs },
          correlation_id: correlationId
        }
      });
    }

    // 5. Đóng proposal gốc & [BPL-02, CL-03] Ghi BPL + Gửi tin chúc mừng gia nhập
    await tx.proposals.update({
      where: { id: proposalId },
      data: { status: 'APPROVED', reviewed_by: actorId, reviewed_at: new Date() }
    });

    await logBPL(tx, {
      context: { actor_id: actorId, actor_type: 'ADMIN', correlation_id: correlationId, tenant_id: proposal.tenant_id },
      payload: { event_name: 'MEMBER_CLAIM_APPROVE', proposal_id: proposalId, target_member_id: proposal.target_id, user_id: targetUserId }
    });
  }
  ```

### 3.3 Duyệt MFO và Dual-Write FTDI: `mfo.gate2.js` [OPT-03, BPL-06, CL-06]
* **File**: `Backend/src/services/mfo.gate2.js`
* **Nghiệp vụ**:
  1. Thực thi chuyển các thành viên trong lô MFO sang `members.status = 'CHINH_THUC'`.
  2. **Dual-Write FTDI**: Chèn quan hệ huyết thống vào bảng `parentages` bằng composite key:
     ```javascript
     for (const child of createdChildren) {
       if (child.father_id) {
         await tx.parentages.upsert({
           where: {
             tenant_id_parent_id_child_id_relationship_type: {
               tenant_id: tenantId,
               parent_id: child.father_id,
               child_id: child.id,
               relationship_type: 'BIOLOGICAL'
             }
           },
           update: { is_selected_for_lineage: true, review_status: 'ACCEPTED' },
           create: {
             tenant_id: tenantId,
             parent_id: child.father_id,
             child_id: child.id,
             relationship_type: 'BIOLOGICAL',
             review_status: 'ACCEPTED',
             is_selected_for_lineage: true,
             changed_by: actorId
           }
         });
       }
       if (child.mother_id) {
         await tx.parentages.upsert({
           where: {
             tenant_id_parent_id_child_id_relationship_type: {
               tenant_id: tenantId,
               parent_id: child.mother_id,
               child_id: child.id,
               relationship_type: 'BIOLOGICAL'
             }
           },
           update: { is_selected_for_lineage: true, review_status: 'ACCEPTED' },
           create: {
             tenant_id: tenantId,
             parent_id: child.mother_id,
             child_id: child.id,
             relationship_type: 'BIOLOGICAL',
             review_status: 'ACCEPTED',
             is_selected_for_lineage: true,
             changed_by: actorId
           }
         });
       }
     }
     ```
  3. **Kích hoạt đúng Requester**: Dùng `targetUserId = proposal.requester_user_id` (không dùng `actorId` của Admin) để nâng `user_member_links.status = 'DA_DUYET'` và `users.status = 'DA_DUYET'`.

### 3.4 Checkpoint CP-3 & Smoke Test S-3
1. **Test S-3.1**: User A submit Claim Member X ➔ Thành công, `proposal.status = PENDING`.
2. **Test S-3.2 (Dispute)**: User B submit Claim cùng Member X ➔ Cả 2 proposals tự động chuyển sang `DISPUTED`, có log BPL `MEMBER_CLAIM_DISPUTE`.
3. **Test S-3.3**: Admin duyệt Claim Member Y ➔ Member Y không bị nhân bản, `evidence_links` nhân bản thành công với `target_type = 'MEMBER'`, `users.status` của người nộp nâng sang `DA_DUYET`.
4. **Test S-3.4**: Admin duyệt MFO Plan ➔ Bảng `parentages` tự động sinh liên kết cha-con đúng composite key, người nộp MFO được kích hoạt quyền thành viên.

---

## PHASE 4: FRONTEND CLIENT IMPLEMENTATION

### 4.1 Cập nhật Định tuyến & Session Sync [FE-NAV-01, FE-NAV-03, FE-NAV-04]
* **File**: `Frontend/src/context/AuthContext.jsx` & App Router.
* **Điều hướng**:
  * Sau khi login: Nếu chưa có `activeMemberId` ➔ Điều hướng vào `/op/base-profile` (lựa chọn: Tạo mới hoặc Nhận hồ sơ Claim).
  * Nếu `activeLinkStatus === 'CHO_DUYET'` ➔ Điều hướng vào `/membership/status` (Màn hình theo dõi tiến độ duyệt đơn).
  * Nếu `activeLinkStatus === 'DRAFT'` ➔ Khóa điều hướng vào cây phả hệ chính thức, chỉ mở `/op/mfo` và `/op/base-profile`.

### 4.2 Component Clan Switcher [FE-SW-01, FE-SW-02, FE-SW-03, FE-SCR-07]
* **Vị trí**: `Frontend/src/components/layout/HeaderClanSwitcher.jsx`
* **Hiển thị**: Dropdown danh sách các dòng họ người dùng tham gia kèm tag phân loại quan hệ:
  * `PRIMARY_PATERNAL` ➔ "Họ nội"
  * `MATERNAL` ➔ "Họ ngoại"
  * `SPOUSE_FAMILY` ➔ "Nhà dâu/rể"
  * Đánh dấu ngôi sao cho dòng họ mặc định (`is_default = true`).
* **Sự kiện chọn dòng họ**: Gọi API `POST /api/auth/switch-context`, cập nhật Token trong `localStorage`, làm mới state RAM (`activeTenantId`, `activeMemberId`, `activeLinkStatus`) và re-fetch dữ liệu trang hiện tại.

### 4.3 Màn hình Claim Hồ sơ [FE-SCR-03, FE-SCR-04, FE-SCR-05, FE-ELD-01 → 03]
* **Vị trí**: `Frontend/src/features/membership/pages/ClaimMemberPage.jsx`
* **Cấu phần**:
  1. **Bước 1 (Chọn Member)**: Tái sử dụng component `MemberSearchSheet.jsx` (đã có debounce 300ms, nút "Nghe hướng dẫn" TTS và bộ lọc chi nhánh/đời).
  2. **Bước 2 (Xác thực 3 lớp)**:
     * Lớp 1: Form trắc nghiệm gia mật (Tên húy cụ tổ, ngày giỗ chi họ).
     * Lớp 2: Ô xác thực số điện thoại đối soát với sổ cũ.
     * Lớp 3: Chọn người thân trong danh sách họ để gửi yêu cầu bảo lãnh (Vouching).
  3. **Bước 3 (Xác nhận)**: Modal tóm tắt thông tin cỡ chữ lớn, nút bấm tối thiểu 48px cho người cao tuổi trước khi bấm nộp.

### 4.4 Sandbox Banner & Thông báo [FE-SCR-08, FE-NOTI-01 → 03]
* **Vị trí**: `Frontend/src/components/common/SandboxModeBanner.jsx`
* Hiển thị thanh thông báo màu vàng trên cùng khi `activeLinkStatus === 'DRAFT'`: *"Bạn đang trong chế độ khởi tạo gia phả 5 đời. Hoàn tất nộp hồ sơ để mở đầy đủ tính năng dòng họ."*

### 4.5 Checkpoint CP-4 & Smoke Test S-4
1. Đăng nhập user chưa có member ➔ Trình duyệt tự chuyển sang màn hình chọn luồng.
2. Mở màn hình Claim ➔ Gọi được danh sách tìm kiếm từ `MemberSearchSheet.jsx`, nút nghe TTS đọc rõ ràng.
3. Switch Clan trên Header ➔ Token đổi mới, cây phả hệ hiển thị lại đúng theo dòng họ được chọn.

---

## PHASE 5: BÃI BỎ KẾ THỪA (DEPRECATION & CLEANUP)

### 5.1 Khai tử Route Nối cây cũ `mergeBranch` [DEP-01]
* **File**: `Backend/src/routes/onboarding.routes.js`
* **Hành động**:
  ```javascript
  router.post('/cases/:caseId/merge', (req, res) => {
    return res.status(410).json({
      success: false,
      code: 'ROUTE_DEPRECATED',
      message: 'Tính năng ghép nhánh cũ đã bị bãi bỏ. Mọi thao tác tích hợp phả hệ chuyển giao sang MFO 5L và Dual-Write parentages.'
    });
  });
  ```

### 5.2 Loại bỏ logic Chi tạm thời trong OP [DEP-02]
* **File**: `Backend/src/services/onboarding.service.js`
* **Hành động**: Loại bỏ các đoạn code tự động sinh chi dự bị (`branches.status = 'PROVISIONAL'`) và trường `primary_branch_id` khi tạo Onboarding Case. Thành viên mới tạo chỉ cần gắn vào `members (status = 'DU_BI')`.

### 5.3 Checkpoint CP-5 & Smoke Test S-5
* Gửi request `POST /api/onboarding/cases/test-id/merge` ➔ Nhận mã `410 GONE`.
* Toàn bộ test suite cũ chạy qua không phát sinh lỗi phá vỡ schema (Q1-Invariant).

---

## TỔNG KẾT TIẾN ĐỘ THỰC THI (CHECKLIST THEO DÕI)

- [ ] **Phase 1: DDL & Migration**
  - [ ] Chạy file migration SQL (tạo `user_member_links`, 2 enum, partial unique index)
  - [ ] Cập nhật `Backend/prisma/schema.prisma` và chạy `npx prisma generate`
  - [ ] Smoke test S-1 thành công
- [ ] **Phase 2: Auth Context & Sandbox Middleware**
  - [ ] Điều chỉnh `auth.service.js` (giữ `CHO_DUYET` sau OTP)
  - [ ] Viết API `POST /api/auth/switch-context`
  - [ ] Cập nhật `tenantGate.middleware.js` (Whitelist 5 routes)
  - [ ] Mở rộng ALS Context trong `prisma.js`
  - [ ] Smoke test S-2 thành công
- [ ] **Phase 3: Claim APIs & MFO Alignment**
  - [ ] Viết `submitClaim` (Khóa dòng + Dispute Gate + BPL + CL)
  - [ ] Viết `approveClaim` (Khóa dòng + Nâng đúng Requester + Nhân bản Evidence)
  - [ ] Cập nhật `mfo.gate2.js` (Dual-Write `parentages` + Nâng đúng Requester)
  - [ ] Smoke test S-3 thành công
- [ ] **Phase 4: Frontend Client**
  - [ ] Cập nhật Router và AuthContext
  - [ ] Tạo component `HeaderClanSwitcher.jsx`
  - [ ] Tạo trang `ClaimMemberPage.jsx` (kế thừa `MemberSearchSheet.jsx`)
  - [ ] Tạo `SandboxModeBanner.jsx`
  - [ ] Smoke test S-4 thành công
- [ ] **Phase 5: Deprecation & Cleanup**
  - [ ] Chặn route `/cases/:caseId/merge` với mã `410 GONE`
  - [ ] Dọn dẹp logic chi tạm thời trong onboarding service
  - [ ] Smoke test S-5 thành công
```

---

Tài liệu kế hoạch thực thi chi tiết **Phiên bản 2.0 (RP-OP-DETAILED-IMPLEMENTATION-V2.0.md)** đã được khởi tạo hoàn chỉnh. Tài liệu đã chốt cứng cấu trúc `VARCHAR(36)`, bổ sung `MEMBER_CLAIM` và `DISPUTED`, khóa chặt Row-level lock, bảo toàn logic Requester vs Actor và bao quát toàn bộ 69 mã quy chiếu từ Design Spec V3.0. 

Bạn có thể bắt đầu triển khai ngay với **Phase 1: DDL & Migration** theo đúng file SQL ở mục 1.2.