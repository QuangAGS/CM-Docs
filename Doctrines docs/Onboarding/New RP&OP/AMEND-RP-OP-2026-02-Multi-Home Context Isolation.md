# AMEND-RP-OP-2026-02 — Multi-Home Context Isolation

| Trường | Giá trị |
|--------|---------|
| Mã | AMEND-RP-OP-2026-02 |
| Phiên bản | V1.2 (caveat thực thi) |
| Tiêu đề | Phương pháp luận Multi-Home: chuyển ngữ cảnh dòng họ mà không làm hỏng Prisma Client và không rò dữ liệu |
| Phạm vi | New RP&OP (AMEND-RP-OP-2026-01) và mọi API đọc/ghi theo tenant |
| Trạng thái | Draft — chờ đóng băng |
| Ngày | 2026-11-11 |
| SSOT | `user_member_links`, JWT claims, AsyncLocalStorage, Prisma Client Extension |

---

## 1. Mục đích

Cho phép một End User thuộc nhiều dòng họ chuyển ngữ cảnh làm việc tức thì, đồng thời:

- Context đang chọn (`activeTenantId`, `activeMemberId`, `roleInTenant`) đổi theo token mới.
- Prisma Client là singleton + `$extends` một lần — không tạo lại mỗi request, không cạn pool, không race giữa hai request.
- Bảng nghiệp vụ không rò sang dòng họ khác (fail-closed).
- Bảng danh tính (`users`, `tenants`, `user_member_links`) không bị lọc nhầm theo `tenant_id` của token mới.
- Job nền không mất ALS.
- Thao tác nhạy cảm không tin JWT đã bị thu hồi quyền.
- Code thực thi không vấp 4 bẫy runtime: `updateMany` chỉ trả `count`, `reload` nuốt `navigate`, switch kéo dài phiên vô hạn, transaction đi nhầm client.

RP&OP kết thúc khi có liên kết hợp lệ. Multi-Home là cách EU **dùng** các liên kết `DA_DUYET` đó.

---

## 2. Vấn đề

### 2.1. Bản chất

```text
users 1 ── * user_member_links * ── 1 tenants
                └── member_id → members
```

- `users`: AuthN toàn cục.
- `user_member_links`: AuthZ SSOT (`role_in_tenant`, `link_type`, `status`, `is_default`).
- `users.tenant_id` / `users.member_id`: home mặc định, không phải context đang làm việc.

### 2.2. Lỗi đã gặp

| Triệu chứng | Nguyên nhân |
|-------------|-------------|
| `GET /api/auth/me` → 401 | `prisma.users` bị inject `tenant_id` token mới; `users.tenant_id` vẫn là tenant gốc |
| `GET /api/me/profile` → 401 → `/auth?mode=login` | `resolveMemberActor` cùng lỗi; dùng `users.member_id` / `users.tenant_id` |
| Chỉ vào được tenant default | Token đúng, identity/profile fail → interceptor 401 xóa phiên |

### 2.3. Tử huyệt đã đóng ở V1.1

1. Inject `tenant_id` vào `findUnique` → crash Prisma.
2. Scope nhầm `users` → 401.
3. Fail-open khi thiếu ALS.
4. Check-then-act → TOCTOU.
5. `findUnique` lệch tenant trả 403 → ID enumeration.
6. Job nền mất ALS.
7. JWT còn hạn sau khi link bị thu hồi.
8. `include` lồng không được extension lọc cấp con.

### 2.4. Bốn bẫy runtime khi code (V1.2)

1. **`updateMany` chỉ trả `{ count }`** — controller đang `res.json(updatedRecord)` sẽ vỡ FE.
2. **`switchContext` gọi `window.location.reload()`** — `navigate(path)` phía sau không chạy; user không tới `/admin`.
3. **Switch cấp JWT `expiresIn: '24h'` mới** — switch qua lại gia hạn phiên vô hạn.
4. **`$transaction` trên `basePrisma`** — lệnh trong `tx` không được extension lọc tenant.

---

## 3. Phương pháp giải quyết

### 3.1. Phân làn SSOT

| Mục tiêu | Nguồn | Cách dùng |
|----------|--------|-----------|
| AuthN | `users` | `basePrisma.users` theo `id` / phone / email |
| AuthZ | `user_member_links` | `(user_id, tenant_id)` → member, role, status |
| Phiên | JWT claims | `activeTenantId`, `activeMemberId`, `roleInTenant`, … |
| Phả hệ | `members`, … | `prisma` extension; `include` lọc tường minh |
| UI | token + full navigation | `location.href = path` khi đổi tenant, không `navigate` sau `reload` |

**Cấm:** dùng `users.tenant_id` / `users.member_id` làm context hiện tại.

### 3.2. Snapshot JWT

```json
{
  "userId": "usr_123",
  "activeTenantId": "tnt_001",
  "activeMemberId": "mem_456",
  "roleInTenant": "CLAN_ADMIN",
  "linkType": "PRIMARY_PATERNAL",
  "activeLinkStatus": "DA_DUYET"
}
```

### 3.3. Switch-context và TTL

1. `POST /api/auth/switch-context { targetTenantId }`.
2. Kiểm link `DA_DUYET` bằng `basePrisma`.
3. Ký JWT mới.
4. **TTL:** kế thừa `exp` của token gốc, hoặc trần cố định (8h–12h). Không reset 24h mỗi lần switch.
5. Phiên dài dùng refresh token riêng, không dùng switch để gia hạn.

```js
const incoming = jwt.decode(req.headers.authorization?.split(' ')[1] || '');
const exp = incoming?.exp;
const maxExp = Math.floor(Date.now() / 1000) + 12 * 3600;
const expiresIn = exp ? Math.max(60, Math.min(exp, maxExp) - Math.floor(Date.now() / 1000)) : 8 * 3600;

jwt.sign(claims, secret, { expiresIn });
```

### 3.4. ALS — request và worker

Request: `tenantStorage.run(store, next)`.

Worker: payload bắt buộc có `activeTenantId` và `actorId`; worker `tenantStorage.run` trước khi query. Bypass chỉ cho job hệ thống.

### 3.5. Prisma extension

| Thao tác | Quy tắc |
|----------|---------|
| Global models | Không inject |
| Tenant models, thiếu context | Fail-closed |
| `findMany` / `findFirst` / `count` | Inject `where.tenant_id` |
| `findUnique` lệch tenant | **`null`** → controller 404. Cấm 403 |
| `create` | Force `tenant_id` với actor thường |
| Mutate theo id | `updateMany` / `deleteMany` `{ id, tenant_id }`. `count === 0` → 404. **Sau đó `findFirst` để trả record** |
| `include` lồng | Service lọc con tường minh |
| Transaction | Gọi `prisma.$transaction`, không `basePrisma.$transaction`, nếu muốn lọc tenant |

### 3.6. Heavy-write guard

Ghi nặng (duyệt hồ sơ, sửa phả đồ, quỹ, đổi role) tái kiểm `user_member_links` `DA_DUYET`. Đọc thường có thể tin claims.

### 3.7. Frontend — một đường chuyển trang

- Cùng tenant, đổi vai trò: `navigate(path)`.
- Khác tenant: `switchContext(tenantId, path)` → BE trả token → `window.location.href = path` (reload và đúng URL).
- Không `reload()` rồi `navigate()`.

---

## 4. Các bước thực hiện

### Bước 0 — Hợp đồng

- [ ] Claims login / switch đủ.
- [ ] FE seed `availableClans` từ payload.
- [ ] Switch không reset TTL 24h.

### Bước 1 — Hết 401

- [ ] `/auth/me` và `resolveMemberActor` dùng `basePrisma` + claims.

### Bước 2 — Extension + helper mutate

- [ ] Fail-closed, `findUnique` → null, `updateMany` + re-read.

### Bước 3 — ALS + worker + transaction

- [ ] Middleware bind.
- [ ] Job mang tenant.
- [ ] Transaction nghiệp vụ đi `prisma.$transaction`.

### Bước 4 — FE navigation

- [ ] `switchContext(tenantId, redirectUrl)` dùng `location.href`.
- [ ] Switcher không `navigate` sau khi đã reload.

### Bước 5 — Kiểm thử

| # | Case | Kỳ vọng |
|---|------|---------|
| 1 | 1 tenant USER | `/op` |
| 2 | CLAN_ADMIN chọn Quản trị | Tới `/admin`, không kẹt URL cũ |
| 3 | Switch tenant phụ | `/me` 200, profile 200 |
| 4 | `updateMany` member | Response là object member, không phải `{ count: 1 }` |
| 5 | `findUnique` id họ khác | null / 404 |
| 6 | Không ALS | Fail-closed |
| 7 | Switch 20 lần | `exp` không bị kéo vô hạn |
| 8 | `$transaction` trên `prisma` | Lệnh trong tx vẫn lọc tenant |
| 9 | Link `TU_CHOI`, heavy write | 403 |
| 10 | Worker có tenant trong payload | Không fail-closed oan |

---

## 5. Ví dụ code

### 5.1. Helper mutate an toàn (tránh bẫy `count`)

```js
async function updateMemberInTenant(memberId, patch, activeTenantId) {
  const result = await prisma.members.updateMany({
    where: { id: memberId, tenant_id: activeTenantId, deleted_at: null },
    data: patch,
  });
  if (result.count === 0) {
    throw createError('NOT_FOUND', 'Không tìm thấy thành viên trong dòng họ.');
  }
  const updated = await prisma.members.findFirst({ where: { id: memberId } });
  return updated;
}
```

Controller vẫn:

```js
const updatedMember = await memberService.update(id, data);
res.json({ status: 'success', data: updatedMember });
```

### 5.2. Switch FE — một lệnh chuyển trang

```js
const switchContext = async (targetTenantId, redirectUrl = null) => {
  const data = await membershipApi.switchContext(targetTenantId);
  const payload = data?.data || data;
  if (payload.token) {
    localStorage.setItem('auth_token', payload.token);
    localStorage.setItem('token', payload.token);
  }
  if (redirectUrl) {
    window.location.href = redirectUrl;
    return;
  }
  window.location.reload();
};

const enterClanAs = async (clan, path) => {
  if (clan.tenantId !== activeContext?.activeTenantId) {
    await switchContext(clan.tenantId, path);
    return;
  }
  navigate(path, { replace: true });
};
```

### 5.3. TTL khi switch (BE)

```js
function resolveSwitchExpiresIn(authHeader) {
  const raw = (authHeader || '').replace(/^Bearer\s+/i, '');
  const decoded = raw ? jwt.decode(raw) : null;
  const now = Math.floor(Date.now() / 1000);
  const ceiling = now + 12 * 3600;
  if (decoded?.exp && decoded.exp > now) {
    return Math.max(60, Math.min(decoded.exp, ceiling) - now);
  }
  return 8 * 3600;
}

const token = jwt.sign(claims, secret, {
  expiresIn: resolveSwitchExpiresIn(req.headers.authorization),
});
```

### 5.4. Transaction phải đi client đã extend

```js
// ĐÚNG — tx vẫn qua extension, ALS còn hiệu lực trong request
await prisma.$transaction(async (tx) => {
  await tx.members.updateMany({
    where: { id: memberId, tenant_id: activeTenantId },
    data: patch,
  });
});

// SAI cho dữ liệu phả hệ — mất bộ lọc tenant của extension
await basePrisma.$transaction(async (tx) => {
  await tx.members.findMany();
});
```

`basePrisma.$transaction` chỉ dùng cho thao tác identity / job đã bypass có chủ đích.

### 5.5. `/auth/me` và actor (giữ V1.1)

```js
const row = await basePrisma.users.findFirst({
  where: { id: req.user.userId, deleted_at: null },
});
const tenant = await basePrisma.tenants.findFirst({
  where: { id: req.user.activeTenantId, deleted_at: null },
});
```

```js
const member = await basePrisma.members.findFirst({
  where: {
    id: reqUser.activeMemberId,
    tenant_id: reqUser.activeTenantId,
    deleted_at: null,
  },
});
```

### 5.6. Heavy-write guard

```js
async function assertActiveLink(req) {
  const link = await basePrisma.user_member_links.findFirst({
    where: {
      user_id: req.user.userId,
      tenant_id: req.user.activeTenantId,
      deleted_at: null,
      status: 'DA_DUYET',
    },
  });
  if (!link) deny('LINK_REVOKED', 'Tư cách tại dòng họ này không còn hiệu lực.', 403);
  return link;
}
```

### 5.7. Worker

```js
await tenantStorage.run(
  { tenantId: job.activeTenantId, userId: job.actorId, allowSystemBypass: false },
  () => processJob(job)
);
```

### 5.8. Include lồng

```js
await prisma.branches.findMany({
  include: {
    members: { where: { tenant_id: getTenantContext().tenantId, deleted_at: null } },
  },
});
```

---

## 6. Không làm

- Không tạo Prisma Client mới mỗi switch.
- Không inject `tenant_id` vào `findUnique`.
- Không đưa `users` vào auto-inject.
- Không dùng `users.tenant_id` làm context active.
- Không fail-open khi thiếu ALS.
- Không trả 403 khi `findUnique` lệch tenant.
- Không trả `{ count }` của `updateMany` thẳng cho FE.
- Không `reload()` rồi `navigate()`.
- Không reset TTL 24h mỗi lần switch.
- Không `$transaction` dữ liệu họ trên `basePrisma`.
- Không dispatch job thiếu `activeTenantId`.
- Không tin JWT một mình trên heavy write.

---

## 7. Đối chiếu phiên bản

| Điểm | V1.1 | V1.2 |
|------|------|------|
| Mutate theo id | `updateMany` | `updateMany` + `findFirst` trả object |
| Đổi tenant trên FE | `switch` + `navigate` | `location.href = path` |
| TTL switch | Chưa khóa | Kế thừa `exp` hoặc trần 8h–12h |
| Transaction | Chưa nói | Bắt buộc `prisma.$transaction` cho dữ liệu họ |
| `findUnique` lệch tenant | `null` | Giữ |
| Worker ALS | Có | Giữ |
| Heavy-write guard | Có | Giữ |
