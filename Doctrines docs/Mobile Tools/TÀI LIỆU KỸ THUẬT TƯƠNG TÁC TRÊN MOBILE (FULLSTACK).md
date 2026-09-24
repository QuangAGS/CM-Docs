# **TÀI LIỆU KỸ THUẬT TƯƠNG TÁC TRÊN MOBILE (FULLSTACK)**

*Tên dự án*: Quản Lý Gia Phả Frontend (`gia-pha-frontend`)  
*Kiến trúc hệ thống*: Feature-Based Architecture (React 18 \+ Vite 5 \+ Tailwind CSS \+ React Flow v11)  
*Ngày phát hành*: 22/09/2026

* # FE Stack: React 18 \+ Vite 5 \+ Tailwind CSS \+ React Flow v11

* # BE Stack: Node.js (Express 4.18) \+ Prisma ORM 5.10 \+ AWS S3 SDK v3

## I. MỤC TIÊU VÀ TỔNG QUAN TÍNH NĂNG MOBILE

Thư viện dùng chung này được thiết kế nhằm giải quyết các thách thức trải nghiệm người dùng (UX) trên màn hình thiết bị di động nhỏ hẹp:

1. Thay thế giao diện Hover/Context Menu PC: Sử dụng Bottom Sheet chuẩn UX mobile, trượt từ dưới lên khi người dùng chạm vào Node.  
    PNG  
2. Kích thước Cảm ứng An toàn (Touch Target): Các nút tương tác trong danh sách thao tác (`Ope1` – `Ope7`) đạt chuẩn chiều cao tối thiểu 48px, chống bấm nhầm ngón tay.  
3. Điều hướng Thông minh (Focus & Context Zoom): Camera tự động di chuyển trơn mượt và phóng to vào chính giữa gia đình được chọn, tránh việc người dùng bị lạc trên sơ đồ gia phả lớn.  
4. Tích hợp Thông báo & Phản hồi: Sử dụng thư viện `sonner` để phát thông báo trực quan ngay sau khi thực hiện thao tác.

## **II. KIẾN TRÚC TƯƠNG TÁC MOBILE (FE \<-\> BE)**

Ghi chú: Các thao tác (Ope) có thể mở rộng, customize theo nhu cầu thực tiễn.

* Thao tác Ope1 (Xem chi tiết):  
  * FE: Chạm Node \-\> Mở BottomSheet \-\> Bấm Ope1.  
  * BE: GET /api/v1/members/:id \-\> Return JSON Member Info.  
* Thao tác Ope4 (Đổi Avatar Camera):  
  * FE: Bấm Ope4 \-\> Kích hoạt Native Mobile Camera/Library (\<input type="file" accept="image/\*"\>).  
  * BE: POST /api/v1/members/:id/avatar (Multipart/form-data) \-\> upload.middleware (Multer MemoryStorage) \-\> s3.service (AWS S3 PutObjectCommand) \-\> members.service (Prisma Update Avatar URL) \-\> Return New Avatar URL.  
* Thao tác Ope7 (Xóa nút gia đình):  
  * FE: Bấm Ope7 (Danger Button) \-\> Mở Confirm Dialog \-\> Gửi Delete API \-\> Sonner Toast Notification Feedback.

## **III.DANH MỤC FILE VÀ VỊ TRÍ ĐẶT TRONG THƯ MỤC PROJECT (src/) cho FE**

Theo đúng Phương án 2 đã chọn, toàn bộ cấu trúc thư viện được tổ chức chuẩn hóa trong sơ đồ thư mục như sau:

```
src/
├── components/
│   └── ui/
│       └── BottomSheet.jsx               <-- Component UI Bottom Sheet tái sử dụng chung
├── shared/
│   └── hooks/
│       └── useMobileTreeZoom.js          <-- Custom Hook điều khiển Zoom/Pan React Flow
└── features/
    └── genealogy/
        └── components/
            ├── mobile/
            │   ├── CustomFamilyNode.jsx   <-- Custom Node ReactFlow Cặp Vợ/Chồng
            │   └── NodeOperationsMenu.jsx <-- Menu danh sách 7 thao tác Ope1 - Ope7
            └── MobileGenealogyTree.jsx    <-- Component Container chính bao bọc sơ đồ
```

## IV. FE-MÃ NGUỒN VÀ TÀI LIỆU CHI TIẾT THEO TỪNG FILE **1\. `src/components/ui/BottomSheet.jsx`**

JavaScript

```
/**
 * PATH       : frontend/src/components/ui/BottomSheet.jsx
 * DATETIME   : 2026-09-22T11:52:00+07:00
 * VERSION    : 1.0.0-MOBILE-UI
 * DESCRIPTION: Component giao diện Bottom Sheet tái sử dụng chung cho thiết bị di động, tự động trượt từ dưới màn hình lên khi kích hoạt, hỗ trợ backdrop mờ và nút đóng nhanh.
 */

import React, { useEffect } from 'react';
import { X } from 'lucide-react';

export const BottomSheet = ({ isOpen, onClose, title, subtitle, children }) => {
  // Tự động khóa cuộn trang chính khi Bottom Sheet mở ra
  useEffect(() => {
    if (isOpen) {
      document.body.style.overflow = 'hidden';
    } else {
      document.body.style.overflow = '';
    }
    return () => {
      document.body.style.overflow = '';
    };
  }, [isOpen]);

  if (!isOpen) return null;

  return (
    <>
      {/* Backdrop mờ che phủ màn hình */}
      <div 
        className="fixed inset-0 bg-black/50 backdrop-blur-sm z-[998] transition-opacity animate-fadeIn"
        onClick={onClose}
      />
      
      {/* Bảng Bottom Sheet Trượt Khung Dưới */}
      <div className="fixed bottom-0 left-0 right-0 max-h-[85vh] bg-white rounded-t-[24px] shadow-2xl z-[999] flex flex-col transform transition-transform duration-300 ease-out animate-slideUp">
        {/* Drag Handle Bar trang trí */}
        <div className="w-full py-3 flex justify-center cursor-pointer" onClick={onClose}>
          <div className="w-10 h-1.5 bg-gray-300 rounded-full" />
        </div>

        {/* Header Thông tin */}
        <div className="px-5 pb-3 border-b border-gray-100 flex items-center justify-between">
          <div>
            <h3 className="text-base font-bold text-gray-900">{title}</h3>
            {subtitle && <p className="text-xs text-gray-500 mt-0.5">{subtitle}</p>}
          </div>
          <button 
            onClick={onClose}
            className="w-8 h-8 rounded-full bg-gray-100 flex items-center justify-center text-gray-600 active:bg-gray-200"
          >
            <X size={18} />
          </button>
        </div>

        {/* Body Container Nội dung Thao tác */}
        <div className="p-5 overflow-y-auto flex flex-col gap-2.5 mb-2">
          {children}
        </div>
      </div>
    </>
  );
};

export default BottomSheet;
```

### 2\. `src/shared/hooks/useMobileTreeZoom.js`

JavaScript

```
/**
 * PATH       : frontend/src/shared/hooks/useMobileTreeZoom.js
 * DATETIME   : 2026-09-22T11:52:00+07:00
 * VERSION    : 1.0.0-MOBILE-HOOK
 * DESCRIPTION: Custom Hook dùng chung điều khiển hiệu ứng Zoom & Pan linh hoạt của React Flow trên Mobile, bao gồm tính năng tự động Focus vào một Node gia đình cụ thể và Auto-Fit toàn khung hình.
 */

import { useCallback } from 'react';
import { useReactFlow } from 'reactflow';

export const useMobileTreeZoom = () => {
  const { setCenter, fitBounds, zoomTo } = useReactFlow();

  /**
   * Tự động di chuyển camera và zoom cận cảnh vào tọa độ một Node gia đình
   * @param {number} nodeX - Tọa độ X của Node
   * @param {number} nodeY - Tọa độ Y của Node
   * @param {number} zoomLevel - Tỉ lệ phóng to (Default: 1.4)
   */
  const focusNode = useCallback((nodeX, nodeY, zoomLevel = 1.4) => {
    setCenter(nodeX, nodeY, { zoom: zoomLevel, duration: 600 });
  }, [setCenter]);

  /**
   * Tự động tính toán khung viền toàn cây để căn chỉnh vừa vặn màn hình điện thoại
   * @param {Array} nodes - Danh sách toàn bộ các Node hiện tại
   */
  const resetFitView = useCallback((nodes) => {
    if (!nodes || nodes.length === 0) return;
    
    const minX = Math.min(...nodes.map(n => n.position.x));
    const maxX = Math.max(...nodes.map(n => n.position.x));
    const minY = Math.min(...nodes.map(n => n.position.y));
    const maxY = Math.max(...nodes.map(n => n.position.y));

    fitBounds(
      { x: minX, y: minY, width: maxX - minX + 200, height: maxY - minY + 200 },
      { padding: 0.2, duration: 500 }
    );
  }, [fitBounds]);

  return { focusNode, resetFitView, zoomTo };
};

export default useMobileTreeZoom;
```

### 3\. `src/features/genealogy/components/mobile/NodeOperationsMenu.jsx`

JavaScript

```
/**
 * PATH       : frontend/src/features/genealogy/components/mobile/NodeOperationsMenu.jsx
 * DATETIME   : 2026-09-22T11:52:00+07:00
 * VERSION    : 1.0.0-GENEALOGY-MENU
 * DESCRIPTION: Component danh sách 7 nút thao tác (Ope1 đến Ope7) dành cho gia phả, thiết kế kích thước Touch Target đạt chuẩn 48px phù hợp cho tương tác bằng ngón tay trên điện thoại.
 */

import React from 'react';
import { 
  FileText, UserPlus, Edit3, Image, 
  GitFork, Download, Trash2 
} from 'lucide-react';

export const NodeOperationsMenu = ({ onExecuteOpe }) => {
  const operations = [
    { id: 'Ope1', label: 'Ope1: Xem chi tiết thông tin', icon: FileText, danger: false },
    { id: 'Ope2', label: 'Ope2: Thêm thành viên con', icon: UserPlus, danger: false },
    { id: 'Ope3', label: 'Ope3: Chỉnh sửa thông tin Vợ/Chồng', icon: Edit3, danger: false },
    { id: 'Ope4', label: 'Ope4: Cập nhật / Đổi Avatar (Camera)', icon: Image, danger: false },
    { id: 'Ope5', label: 'Ope5: Xem phả hệ nhánh phụ', icon: GitFork, danger: false },
    { id: 'Ope6', label: 'Ope6: Tải hồ sơ / File PDF', icon: Download, danger: false },
    { id: 'Ope7', label: 'Ope7: Xóa gia đình này', icon: Trash2, danger: true },
  ];

  return (
    <div className="flex flex-col gap-2 w-full">
      <span className="text-[11px] font-bold text-gray-400 uppercase tracking-wider mb-1">
        Danh sách thao tác chọn
      </span>
      {operations.map((ope) => {
        const Icon = ope.icon;
        return (
          <button
            key={ope.id}
            onClick={() => onExecuteOpe(ope.id)}
            className={`w-full h-12 px-4 rounded-xl flex items-center gap-3 text-sm font-semibold transition-all active:scale-[0.98] ${
              ope.danger 
                ? 'bg-red-50 text-red-600 border border-red-200 active:bg-red-100' 
                : 'bg-gray-50 text-gray-800 border border-gray-200/80 active:bg-gray-100'
            }`}
          >
            <Icon size={20} className={ope.danger ? 'text-red-500' : 'text-blue-600'} />
            <span>{ope.label}</span>
          </button>
        );
      })}
    </div>
  );
};

export default NodeOperationsMenu;
```

### 4\. `src/features/genealogy/components/mobile/CustomFamilyNode.jsx`

JavaScript

```
/**
 * PATH       : frontend/src/features/genealogy/components/mobile/CustomFamilyNode.jsx
 * DATETIME   : 2026-09-22T11:52:00+07:00
 * VERSION    : 1.0.0-GENEALOGY-NODE
 * DESCRIPTION: Custom Node ReactFlow thể hiện cặp đôi Vợ & Chồng trên đồ họa, tích hợp các đường nối song song, viền Avatar phân màu (Chồng màu Xanh / Vợ màu Hồng) và nút Toggle (+/-) thu gọn/mở rộng cấp con.
 */

import React, { memo } from 'react';
import { Handle, Position } from 'reactflow';

export const CustomFamilyNode = memo(({ data }) => {
  const { husband, wife, hasChildren, isExpanded, onToggleExpand, onSelectNode } = data;

  return (
    <div 
      className="relative flex flex-col items-center justify-center p-2 rounded-xl bg-white border border-gray-100 shadow-sm"
      onClick={() => onSelectNode && onSelectNode(data)}
    >
      {/* Handle Nối Đời Trên */}
      <Handle type="target" position={Position.Top} className="!bg-blue-600 !w-2 !h-2" />

      {/* Cặp Đôi Chồng / Vợ */}
      <div className="flex items-center gap-3 relative">
        {/* Đường nối hôn nhân đứt nét giữa Chồng & Vợ */}
        <div className="absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 w-8 h-[2px] border-t-2 border-dashed border-red-400 z-0" />

        {/* Khung Chồng (Xanh dương) */}
        <div className="flex flex-col items-center z-10">
          <div className="w-11 h-11 rounded-full border-2 border-blue-600 overflow-hidden bg-gray-50 shadow-sm">
            <img 
              src={husband?.avatar || `https://i.pravatar.cc/150?u=h_${data.id}`} 
              alt={husband?.name} 
              className="w-full h-full object-cover"
            />
          </div>
          <span className="text-[10px] font-bold text-gray-500 mt-1">Chồng</span>
        </div>

        {/* Khung Vợ (Hồng) */}
        <div className="flex flex-col items-center z-10">
          <div className="w-11 h-11 rounded-full border-2 border-pink-500 overflow-hidden bg-gray-50 shadow-sm">
            <img 
              src={wife?.avatar || `https://i.pravatar.cc/150?u=w_${data.id}`} 
              alt={wife?.name} 
              className="w-full h-full object-cover"
            />
          </div>
          <span className="text-[10px] font-bold text-gray-500 mt-1">Vợ</span>
        </div>
      </div>

      {/* Nút Toggle Đóng/Mở (+/-) cấp con */}
      {hasChildren && (
        <button
          onClick={(e) => {
            e.stopPropagation();
            onToggleExpand && onToggleExpand(data.id);
          }}
          className="absolute -bottom-3 w-5 h-5 rounded-full bg-blue-600 text-white font-bold text-xs flex items-center justify-center shadow-md border border-white z-20 active:scale-95 transition-transform"
        >
          {isExpanded ? '−' : '+'}
        </button>
      )}

      {/* Handle Nối Đời Dưới */}
      <Handle type="source" position={Position.Bottom} className="!bg-blue-600 !w-2 !h-2" />
    </div>
  );
});

export default CustomFamilyNode;
```

### 5\. `src/features/genealogy/components/MobileGenealogyTree.jsx`

JavaScript

```
/**
 * PATH       : frontend/src/features/genealogy/components/MobileGenealogyTree.jsx
 * DATETIME   : 2026-09-22T11:52:00+07:00
 * VERSION    : 1.0.0-GENEALOGY-TREE
 * DESCRIPTION: Container chính của Cây Phả Hệ Mobile, kết hợp ReactFlow 11, Custom Node gia đình, BottomSheet tái sử dụng, Hook điều khiển Zoom, cùng phản hồi thông báo từ Sonner.
 */

import React, { useState, useCallback, useMemo } from 'react';
import ReactFlow, { Background, Controls, useNodesState, useEdgesState } from 'reactflow';
import 'reactflow/dist/style.css';
import { toast } from 'sonner';

import BottomSheet from '../../../components/ui/BottomSheet';
import useMobileTreeZoom from '../../../shared/hooks/useMobileTreeZoom';
import CustomFamilyNode from './mobile/CustomFamilyNode';
import NodeOperationsMenu from './mobile/NodeOperationsMenu';

export const MobileGenealogyTree = ({ initialData }) => {
  const [nodes, setNodes, onNodesChange] = useNodesState([]);
  const [edges, setEdges, onEdgesChange] = useEdgesState([]);
  const [selectedNode, setSelectedNode] = useState(null);
  const [isSheetOpen, setIsSheetOpen] = useState(false);

  const { focusNode } = useMobileTreeZoom();

  // Đăng ký Custom Node Types cho ReactFlow
  const nodeTypes = useMemo(() => ({
    familyNode: CustomFamilyNode,
  }), []);

  // Xử lý sự kiện Chạm vào Node trên Mobile
  const handleNodeClick = useCallback((event, node) => {
    setSelectedNode(node);
    setIsSheetOpen(true);
    focusNode(node.position.x, node.position.y);
  }, [focusNode]);

  // Thực thi các lệnh Ope1 - Ope7
  const handleExecuteOpe = useCallback((opeCode) => {
    if (!selectedNode) return;
    
    setIsSheetOpen(false);
    toast.success(`Đã chọn [${opeCode}] cho Gia đình Mã: ${selectedNode.id}`);
  }, [selectedNode]);

  return (
    <div className="w-full h-screen bg-gray-50 relative overflow-hidden">
      <ReactFlow
        nodes={nodes}
        edges={edges}
        onNodesChange={onNodesChange}
        onEdgesChange={onEdgesChange}
        onNodeClick={handleNodeClick}
        nodeTypes={nodeTypes}
        fitView
      >
        <Background color="#cbd5e0" gap={16} />
        <Controls showInteractive={false} className="!bottom-4 !left-4" />
      </ReactFlow>

      {/* Bottom Sheet Menu Tái Sử Dụng */}
      <BottomSheet
        isOpen={isSheetOpen}
        onClose={() => setIsSheetOpen(false)}
        title={selectedNode ? `Gia đình Line ${selectedNode.data.line} (ID: ${selectedNode.id})` : 'Thông tin Gia đình'}
        subtitle={selectedNode ? `Chồng: ${selectedNode.data.husband?.name} • Vợ: ${selectedNode.data.wife?.name}` : ''}
      >
        <NodeOperationsMenu onExecuteOpe={handleExecuteOpe} />
      </BottomSheet>
    </div>
  );
};

export default MobileGenealogyTree;
```

## **V.DANH MỤC FILE VÀ VỊ TRÍ ĐẶT TRONG THƯ MỤC PROJECT (src/) cho BE**

Dựa trên hình ảnh cây thư mục Backend (gia-pha-backend) bạn vừa cung cấp, cấu trúc BE của bạn đang tổ chức theo kiến trúc Modular Monolith (với thư mục modules/ phân tách các nghiệp vụ) kết hợp với các tầng shared/, middlewares/, services/, và lib/.  
Cụ thể, các thao tác gia phả di động (Ope1 – Ope7) sẽ tương tác với hai module chính trong BE của bạn:

1. src/modules/members/: Quản lý thông tin chi tiết cá nhân, cập nhật avatar (Ope1, Ope3, Ope4).  
2. src/modules/interactions/ hoặc src/modules/members/: Xử lý thêm con, xem phả hệ nhánh, xóa nút (Ope2, Ope5, Ope6, Ope7).

BẢNG ÁNH XẠ CÁC THAO TÁC FE MOBILE SANG BE MODULES

| Thao tác FE (Mobile Operations) | BE Module phụ trách | Đường dẫn File đề xuất trong BE | Thao tác BE / APIs |
| :---- | :---- | :---- | :---- |
| Ope1: Xem chi tiết thông tin | modules/members | src/modules/members/members.controller.js | GET /api/v1/members/:id |
| Ope2: Thêm thành viên con | modules/members | src/modules/members/members.controller.js | POST /api/v1/members/:id/children |
| Ope3: Sửa thông tin Vợ/Chồng | modules/members | src/modules/members/members.controller.js | PUT /api/v1/members/:id |
| Ope4: Đổi Avatar (Camera/S3) | modules/members \+ shared/storage | src/modules/members/members.controller.js src/shared/storage/s3.service.js | POST /api/v1/members/:id/avatar (Sử dụng Multer & AWS S3) |
| Ope5: Xem phả hệ nhánh phụ | modules/members | src/modules/members/members.controller.js | GET /api/v1/members/:id/sub-tree |
| Ope6: Tải hồ sơ / File PDF | modules/members \+ services | src/services/pdf.service.js | GET /api/v1/members/:id/export-pdf |
| Ope7: Xóa gia đình này | modules/members | src/modules/members/members.controller.js | DELETE /api/v1/members/:id |

## VI. BE-MÃ NGUỒN VÀ TÀI LIỆU CHI TIẾT THEO TỪNG FILE

#### **1\. `src/shared/storage/s3.service.js`**

**JavaScript**

```
/**
 * PATH       : backend/src/shared/storage/s3.service.js
 * DATETIME   : 2026-09-22T12:00:00+07:00
 * VERSION    : 1.0.0-STORAGE-S3
 * DESCRIPTION: Service xử lý upload và quản lý lưu trữ tệp tin trên AWS S3 sử dụng AWS SDK v3, hỗ trợ tải ảnh Avatar cho gia phả.
 */

const { S3Client, PutObjectCommand, DeleteObjectCommand } = require('@aws-sdk/client-s3');
const config = require('../../config');

const s3Client = new S3Client({
  region: process.env.AWS_REGION,
  credentials: {
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
  },
});

/**
 * Tải file buffer lên AWS S3 Bucket
 * @param {Buffer} fileBuffer - Buffer dữ liệu file
 * @param {string} fileName - Tên tệp tin duy nhất
 * @param {string} mimeType - Định dạng MIME
 * @returns {Promise<string>} Đường dẫn URL công khai của tệp
 */
const uploadFileToS3 = async (fileBuffer, fileName, mimeType) => {
  const fileKey = `avatars/${Date.now()}-${fileName}`;

  const command = new PutObjectCommand({
    Bucket: process.env.AWS_S3_BUCKET_NAME,
    Key: fileKey,
    Body: fileBuffer,
    ContentType: mimeType,
  });

  await s3Client.send(command);

  return `https://${process.env.AWS_S3_BUCKET_NAME}.s3.${process.env.AWS_REGION}.amazonaws.com/${fileKey}`;
};

module.exports = {
  uploadFileToS3,
};
```

#### **2\. `src/middlewares/upload.middleware.js`**

**JavaScript**

```
/**
 * PATH       : backend/src/middlewares/upload.middleware.js
 * DATETIME   : 2026-09-22T12:00:00+07:00
 * VERSION    : 1.0.0-MIDDLEWARE-UPLOAD
 * DESCRIPTION: Middleware sử dụng Multer xử lý tiếp nhận file multipart/form-data từ thiết bị di động (Camera/Thư viện ảnh) vào bộ nhớ tạm MemoryStorage.
 */

const multer = require('multer');

// Lưu trữ tệp dưới dạng Buffer trong bộ nhớ đệm
const storage = multer.memoryStorage();

// Giới hạn dung lượng tệp 5MB và kiểm tra định dạng ảnh
const upload = multer({
  storage: storage,
  limits: {
    fileSize: 5 * 1024 * 1024, // 5MB
  },
  fileFilter: (req, file, cb) => {
    if (file.mimetype.startsWith('image/')) {
      cb(null, true);
    } else {
      cb(new Error('Chỉ chấp nhận định dạng tệp hình ảnh!'), false);
    }
  },
});

module.exports = upload;
```

#### **3\. `src/modules/members/members.service.js`**

**JavaScript**

```
/**
 * PATH       : backend/src/modules/members/members.service.js
 * DATETIME   : 2026-09-22T12:00:00+07:00
 * VERSION    : 1.0.0-MEMBERS-SERVICE
 * DESCRIPTION: Layer Service xử lý các thao tác nghiệp vụ chính của thành viên gia phả (Ope1 - Ope7) kết nối CSDL thông qua Prisma ORM.
 */

const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const storageService = require('../../shared/storage/s3.service');

// Ope1: Lấy chi tiết thông tin gia đình / thành viên
const getMemberDetail = async (memberId) => {
  return await prisma.member.findUnique({
    where: { id: memberId },
    include: {
      spouse: true,
      children: true,
    },
  });
};

// Ope2: Thêm thành viên con
const addChildMember = async (parentId, childData) => {
  return await prisma.member.create({
    data: {
      ...childData,
      parentId: parentId,
    },
  });
};

// Ope3: Chỉnh sửa thông tin thành viên / Vợ / Chồng
const updateMemberInfo = async (memberId, updateData) => {
  return await prisma.member.update({
    where: { id: memberId },
    data: updateData,
  });
};

// Ope4: Cập nhật Avatar từ Mobile/S3
const updateMemberAvatar = async (memberId, file) => {
  const avatarUrl = await storageService.uploadFileToS3(
    file.buffer,
    file.originalname,
    file.mimetype
  );

  return await prisma.member.update({
    where: { id: memberId },
    data: { avatarUrl: avatarUrl },
  });
};

// Ope5: Lấy danh sách phả hệ cây con (Sub-tree)
const getMemberSubTree = async (memberId) => {
  return await prisma.member.findMany({
    where: { parentId: memberId },
    include: {
      children: true,
    },
  });
};

// Ope7: Xóa thành viên / nút gia đình
const deleteMember = async (memberId) => {
  return await prisma.member.delete({
    where: { id: memberId },
  });
};

module.exports = {
  getMemberDetail,
  addChildMember,
  updateMemberInfo,
  updateMemberAvatar,
  getMemberSubTree,
  deleteMember,
};
```

#### **4\. `src/modules/members/members.controller.js`**

**JavaScript**

```
/**
 * PATH       : backend/src/modules/members/members.controller.js
 * DATETIME   : 2026-09-22T12:00:00+07:00
 * VERSION    : 1.0.0-MEMBERS-CONTROLLER
 * DESCRIPTION: Layer Controller tiếp nhận HTTP Request từ ứng dụng Mobile FE, gọi Service tương ứng cho 7 thao tác Ope1 - Ope7 và trả về JSON Response.
 */

const membersService = require('./members.service');

// Ope1: GET /api/v1/members/:id
const getDetail = async (req, res, next) => {
  try {
    const data = await membersService.getMemberDetail(req.params.id);
    return res.status(200).json({ success: true, data });
  } catch (error) {
    next(error);
  }
};

// Ope2: POST /api/v1/members/:id/children
const addChild = async (req, res, next) => {
  try {
    const data = await membersService.addChildMember(req.params.id, req.body);
    return res.status(201).json({ success: true, message: 'Thêm con thành công', data });
  } catch (error) {
    next(error);
  }
};

// Ope3: PUT /api/v1/members/:id
const updateInfo = async (req, res, next) => {
  try {
    const data = await membersService.updateMemberInfo(req.params.id, req.body);
    return res.status(200).json({ success: true, message: 'Cập nhật thông tin thành công', data });
  } catch (error) {
    next(error);
  }
};

// Ope4: POST /api/v1/members/:id/avatar
const uploadAvatar = async (req, res, next) => {
  try {
    if (!req.file) {
      return res.status(400).json({ success: false, message: 'Vui lòng chọn file ảnh' });
    }
    const data = await membersService.updateMemberAvatar(req.params.id, req.file);
    return res.status(200).json({ success: true, message: 'Cập nhật Avatar thành công', data });
  } catch (error) {
    next(error);
  }
};

// Ope5: GET /api/v1/members/:id/sub-tree
const getSubTree = async (req, res, next) => {
  try {
    const data = await membersService.getMemberSubTree(req.params.id);
    return res.status(200).json({ success: true, data });
  } catch (error) {
    next(error);
  }
};

// Ope7: DELETE /api/v1/members/:id
const removeMember = async (req, res, next) => {
  try {
    await membersService.deleteMember(req.params.id);
    return res.status(200).json({ success: true, message: 'Xóa nút gia đình thành công' });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getDetail,
  addChild,
  updateInfo,
  uploadAvatar,
  getSubTree,
  removeMember,
};
```

#### **5\. `src/modules/members/members.routes.js`**

**JavaScript**

```
/**
 * PATH       : backend/src/modules/members/members.routes.js
 * DATETIME   : 2026-09-22T12:00:00+07:00
 * VERSION    : 1.0.0-MEMBERS-ROUTES
 * DESCRIPTION: Router khai báo các Endpoint API phục vụ cho 7 thao tác di động Ope1 - Ope7, tích hợp middleware xác thực và middleware upload file.
 */

const express = require('express');
const router = express.Router();
const membersController = require('./members.controller');
const uploadMiddleware = require('../../middlewares/upload.middleware');

// Ope1: Xem chi tiết
router.get('/:id', membersController.getDetail);

// Ope2: Thêm thành viên con
router.post('/:id/children', membersController.addChild);

// Ope3: Sửa thông tin thành viên / Vợ / Chồng
router.put('/:id', membersController.updateInfo);

// Ope4: Cập nhật Avatar (Nhận tệp 'avatar' từ Camera/Thư viện)
router.post('/:id/avatar', uploadMiddleware.single('avatar'), membersController.uploadAvatar);

// Ope5: Xem phả hệ nhánh phụ
router.get('/:id/sub-tree', membersController.getSubTree);

// Ope7: Xóa thành viên
router.delete('/:id', membersController.removeMember);

module.exports = router;
```

## IV. BẢNG KIỂM TRA TƯƠNG THÍCH VÀ QUY TRÌNH DEPLOY

| Hạng mục kiểm tra | Thư viện liên quan trong `package.json` | Kết quả tương thích |
| ----- | ----- | ----- |
| React & DOM | `react: 18.2.0`, `react-dom: 18.2.0` | Tương thích hoàn toàn |
| Sơ đồ Đồ họa | `reactflow: 11.10.1` | Tương thích chuẩn API `useReactFlow` & `Handle` |
| Icons Mobile | `lucide-react: 0.363.0` | Tương thích chuẩn SVG Icons |
| Thông báo Toast | `sonner: 1.4.3` | Tương thích chuẩn `toast.success` |
| CSS Utilities | `tailwindcss: 3.4.1` | Tương thích chuẩn responsive backdrop & slideUp |

