# **TÀI LIỆU KỸ THUẬT KHỞI TẠO KHUNG CÂY GIA ĐÌNH**

**Dự án: myClan.com.vn**  
**Ngày tạo: 22-SEP-2026 14:300**

###  I. MỤC ĐÍCH

**Tạo cây khung gia đình (Cây gồm các node mà mỗi node bao gồm 2 nút Chồng|Vợ) với các điều kiện sau:**  
1\) Khung gồm tổng số đời (N-Lines, Với 1 $\leq {\ }$N  $<{\ }$10).  
2\) Mỗi node là cặp Chồng|Vợ,  được sắp xếp với cạnh trái ngoài cùng của cây là quan hệ trực hệ: Cha/Mẹ \-\> Con.  
3\) Mỗi nút của node đều là box UNKNOWN (hiển thị là "Chưa rõ").  
4\) Tại mỗi node cho phép hiển thị dạng ToolTip (hovercard) thành hai phần.  
Phần 1: Thông tin: Đời: X, thông tin về Chồng và về vợ.  
Phần 2: Các thao tác (số lượng dự kiến 9\) \-\> Có thể chủ động đưa ra danh sách các thao tác thường sử dụng đối với cây gia đình, ví dụ tạo con theo chiều sâu, tạo anh chị em theo chiều ngang; xoá gia đình (Nếu hậu duệ của gia đình không tồn tại); chuyển một node sang nhánh mới,....  
Ví dụ:   
	{ code: 'Ope1', name: 'Xem/Sửa chi tiết gia đình', is\_enabled: true, danger: false },   
{ code: 'Ope2', name: 'Tạo con theo chiều sâu (L+1)', is\_enabled: true, danger: false },   
{ code: 'Ope3', name: 'Tạo anh/chị/em (Chiều ngang)', is\_enabled: true, danger: false },   
{ code: 'Ope4', name: 'Thêm phối ngẫu (Vợ2/Chồng2)', is\_enabled: true, danger: false },   
{ code: 'Ope5', name: 'Cập nhật Avatar / Hồ sơ S3', is\_enabled: true, danger: false },   
{ code: 'Ope6', name: 'Chuyển node sang nhánh mới', is\_enabled: true, danger: false },   
{ code: 'Ope7', name: 'Thu gọn / Mở rộng nhánh', is\_enabled: true, danger: false },   
{ code: 'Ope8', name: 'Xuất sơ đồ nhánh PDF', is\_enabled: true, danger: false },   
{ code: 'Ope9', name: 'Xóa nút gia đình', is\_enabled: true, danger: true },  
5\) hai điều kiện quan trọng:

1. **Ràng buộc Quyền hạn Security**: Chỉ vai trò `CLAN_ADMIN` (hoặc `SYSTEM_ADMIN`) mới có quyền sinh khung cây.  
2. **Ràng buộc Tenant Isolation**: `tenant_id` được trích xuất trực tiếp từ Token đã qua kiểm tra của Middleware xác thực (`auth.middleware.js` & `role.middleware.js`), không cho phép người dùng tự truyền `tenant_id` qua body nhằm chống tấn công leo thang đặc quyền giữa các dòng họ (Cross-tenant breach).

### **I. CÁC TỆP MÃ NGUỒN BACKEND CHUẨN HÓA**

#### **1\. src/modules/members/dto/generate-frame.dto.js**

JavaScript

```
/**
 * PATH       : backend/src/modules/members/dto/generate-frame.dto.js
 * DATETIME   : 2026-09-22T13:30:00+07:00
 * VERSION    : 1.1.0-GENERATE-FRAME-DTO
 * DESCRIPTION: DTO Validate tham số đầu vào cho API sinh khung cây gia phả N-Lines.
 *              Không nhận tenant_id từ Body nhằm bảo đảm Tenant Isolation.
 */

const Joi = require('joi');

const generateFrameSchema = Joi.object({
  lines: Joi.number().integer().min(1).max(10).required().messages({
    'number.base': 'Số đời (lines) phải là một số nguyên',
    'number.min': 'Số đời (lines) tối thiểu là 1',
    'number.max': 'Số đời (lines) tối đa hỗ trợ là 10',
    'any.required': 'Vui lòng truyền tham số số đời (lines)',
  }),
  branch_id: Joi.string().uuid().optional().allow(null),
});

module.exports = {
  generateFrameSchema,
};
```

#### **2\. src/modules/members/members.service.js**

JavaScript

```
/**
 * PATH       : backend/src/modules/members/members.service.js
 * DATETIME   : 2026-09-22T13:30:00+07:00
 * VERSION    : 1.2.0-MEMBERS-TREE-FRAME
 * DESCRIPTION: Service đệ quy sinh Khung Cây Gia Phả N-Lines cho một Dòng họ (Tenant) xác định.
 *              Tích hợp 9 Thao tác (Operations), phân định Cực Trái (Trực hệ/Nội tộc) và các Nút UNKNOWN.
 */

const { prisma } = require('../../lib/prisma');

/**
 * Danh sách 9 Thao tác (Operations) chuẩn mực cho từng Node Gia đình
 */
const DEFAULT_OPERATIONS = [
  { code: 'Ope1', name: 'Xem/Sửa chi tiết gia đình', is_enabled: true, danger: false },
  { code: 'Ope2', name: 'Tạo con theo chiều sâu (L+1)', is_enabled: true, danger: false },
  { code: 'Ope3', name: 'Tạo anh/chị/em (Chiều ngang)', is_enabled: true, danger: false },
  { code: 'Ope4', name: 'Thêm phối ngẫu (Vợ2/Chồng2)', is_enabled: true, danger: false },
  { code: 'Ope5', name: 'Cập nhật Avatar / Hồ sơ S3', is_enabled: true, danger: false },
  { code: 'Ope6', name: 'Chuyển node sang nhánh mới', is_enabled: true, danger: false },
  { code: 'Ope7', name: 'Thu gọn / Mở rộng nhánh', is_enabled: true, danger: false },
  { code: 'Ope8', name: 'Xuất sơ đồ nhánh PDF', is_enabled: true, danger: false },
  { code: 'Ope9', name: 'Xóa nút gia đình', is_enabled: true, danger: true },
];

/**
 * Hàm đệ quy sinh cấu trúc cây khung UNKNOWN
 */
const buildFrameNodeRecursively = (currentLine, maxLines, pathId = '0') => {
  const isLeftmost = !pathId.includes('.2'); // Kiểm tra nút cực trái dòng họ
  
  const node = {
    node_id: `frame-L${currentLine}-${pathId}`,
    generation: currentLine,
    is_leftmost: isLeftmost,
    label: `Đời ${currentLine} ${isLeftmost ? '(Trực hệ Trực thuộc)' : '(Chưa rõ)'}`,
    
    // Khung thành viên Chồng (Cực trái là Nội tộc is_clan = true)
    husband: {
      id: null,
      full_name: 'Chưa rõ (Chồng)',
      is_clan: isLeftmost,
      gender: 'NAM',
      status: 'UNKNOWN',
      shape: 'CIRCLE',
      border_color: isLeftmost ? '#2b6cb0' : '#a0aec0',
    },
    
    // Khung thành viên Vợ (Ngoại tộc is_clan = false)
    wife: {
      id: null,
      full_name: 'Chưa rõ (Vợ)',
      is_clan: false,
      gender: 'NU',
      status: 'UNKNOWN',
      shape: 'CIRCLE',
      border_color: isLeftmost ? '#d53f8c' : '#a0aec0',
    },

    marriage_status: 'DANG_KET_HON',
    operations: DEFAULT_OPERATIONS,
    children: [],
  };

  // Đệ quy sinh 2 con nếu chưa chạm mốc maxLines
  if (currentLine < maxLines - 1) {
    node.children.push(buildFrameNodeRecursively(currentLine + 1, maxLines, `${pathId}.1`));
    node.children.push(buildFrameNodeRecursively(currentLine + 1, maxLines, `${pathId}.2`));
  }

  return node;
};

/**
 * Service chính tạo Khung cây N-Lines cho Dòng họ xác định
 */
const generateFamilyTreeFrame = async ({ lines, tenantId, branch_id }) => {
  // Sinh Cây Khung Đồ Hoạ UNKNOWN N-Đời
  const treeFrame = buildFrameNodeRecursively(0, lines, '0');

  // Lấy dữ liệu đếm số lượng thành viên thực tế của Tenant này (Scope qua TenantContext)
  const totalRealMembers = await prisma.members.count({
    where: {
      tenant_id: tenantId,
      deleted_at: null,
    },
  });

  return {
    lines_count: lines,
    tenant_id: tenantId,
    branch_id: branch_id || null,
    tree: treeFrame,
    meta: {
      total_real_members: totalRealMembers,
      note: 'Khung cây sinh riêng cho Dòng họ (Tenant). Cực trái tô đậm đại diện trực hệ.',
    },
  };
};

module.exports = {
  generateFamilyTreeFrame,
  // ... giữ nguyên các service khác
};
```

#### **3\. src/modules/members/members.controller.js**

JavaScript

```
/**
 * PATH       : backend/src/modules/members/members.controller.js
 * DATETIME   : 2026-09-22T13:30:00+07:00
 * VERSION    : 1.2.0-MEMBERS-CONTROLLER-FRAME
 * DESCRIPTION: Controller xử lý Endpoint tạo Khung Cây Gia Phả N-Lines.
 *              Trích xuất tenantId trực tiếp từ req.user đã qua xác thực của CLAN_ADMIN.
 */

const membersService = require('./members.service');
const { generateFrameSchema } = require('./dto/generate-frame.dto');

// POST /api/v1/members/generate-frame
const generateTreeFrame = async (req, res, next) => {
  try {
    // 1. Validate dữ liệu Body
    const { error, value } = generateFrameSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        success: false,
        message: error.details[0].message,
      });
    }

    // 2. Trích xuất tenantId từ Token của User đã Đăng nhập (req.user)
    const tenantId = req.user.tenantId || req.user.tenant_id;
    if (!tenantId && req.user.role !== 'SYSTEM_ADMIN') {
      return res.status(403).json({
        success: false,
        message: 'Lỗi bảo mật: Bạn chưa gắn thông tin Dòng họ (Tenant).',
      });
    }

    // 3. Gọi Service sinh khung cây
    const result = await membersService.generateFamilyTreeFrame({
      lines: value.lines,
      branch_id: value.branch_id,
      tenantId: tenantId,
    });

    return res.status(200).json({
      success: true,
      message: `Tạo khung cây gia phả ${value.lines} đời thành công cho dòng họ.`,
      data: result,
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  generateTreeFrame,
  // ... các controllers khác
};
```

#### **4\. src/modules/members/members.routes.js**

JavaScript

```
/**
 * PATH       : backend/src/modules/members/members.routes.js
 * DATETIME   : 2026-09-22T13:30:00+07:00
 * VERSION    : 1.2.0-MEMBERS-ROUTES-FRAME
 * DESCRIPTION: Định tuyến Route API sinh Khung Cây Gia Phả N-Lines.
 *              Bắt buộc qua verifyToken + checkRole('CLAN_ADMIN') + tenantStatus.
 */

const express = require('express');
const router = express.Router();
const membersController = require('./members.controller');

// Import Middleware bảo mật & RBAC
const { 
  verifyToken, 
  checkRole, 
  requireActiveTenant 
} = require('../../middlewares/auth.middleware');

/**
 * Route POST /api/v1/members/generate-frame
 * Quền hạn: CHỈ CLAN_ADMIN (hoặc SYSTEM_ADMIN) mới có quyền sinh khung cây
 */
router.post(
  '/generate-frame',
  verifyToken,                  // Xác thực JWT token
  checkRole('CLAN_ADMIN'),      // Kiểm tra quyền CLAN_ADMIN
  requireActiveTenant,          // Đảm bảo dòng họ đã kích hoạt (tenantStatusHeavy)
  membersController.generateTreeFrame
);

module.exports = router;
```

### 

### **II. TÓM TẮT DÒNG CHUYỂN GIAO DỮ LIỆU (FE \<-\> BE)**

Plaintext

```
[1. User mở ứng dụng Mobile FE]
             │
             ▼
[2. FE gọi API POST /api/v1/members/generate-frame { lines: 5 }]
             │
             ▼
[3. BE: auth.middleware & checkRole('CLAN_ADMIN') kiểm tra quyền][cite: 7, 8]
             │
             ▼
[4. BE: members.service đệ quy sinh Tree JSON N-Đời với Nút UNKNOWN]
             │
             ▼
[5. BE trả JSON Response về FE]
             │
             ▼
[6. FE: treeAdapter chuyển đổi Tree JSON -> React Flow Nodes/Edges]
             │
             ▼
[7. FE Render Sơ Đồ Cây 5 Đời trên Mobile]
  - Cực trái Trực hệ: Tô đậm, viền xanh/hồng.
  - Các nút khác: Đường viền nhạt đại diện cho nút UNKNOWN ("Chưa rõ").
  - Chạm vào Node -> Tự động Zoom Cận Cảnh & Mở Bottom Sheet 9 Thao Tác (Ope1 - Ope9).
```

### 

### **II. CẮT LỚP BẢO MẬT VÀ QUY TRÌNH KIỂM TRÁT (TESTING)**

1. **Kiểm tra Phân quyền (RBAC Check):**  
   * Nếu User có role THANH\_VIEN gọi API POST /api/v1/members/generate-frame, checkRole('CLAN\_ADMIN') trong role.middleware.js sẽ lập tức chặn lại và trả về HTTP 403 Forbidden ("Bạn không có quyền truy cập vào chức năng này.").  
2. **Kiểm tra Cô lập Dòng họ (Tenant Isolation):**  
   * Tham số tenant\_id được tự động bóc tách từ JWT Payload của User đăng nhập (req.user.tenantId), nhờ đó loại bỏ nguy cơ can thiệp tenant\_id từ phía client.  
   * Tất cả thao tác truy vấn CSDL Prisma đều được gói trong ngữ cảnh tenantContext chuẩn hóa của hệ thống EGAL.

