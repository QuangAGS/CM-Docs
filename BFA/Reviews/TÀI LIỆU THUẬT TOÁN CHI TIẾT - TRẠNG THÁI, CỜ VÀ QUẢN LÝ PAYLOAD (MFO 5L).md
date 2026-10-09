Dưới đây là **Bản Thuật toán Chi tiết Trạng thái & Payload Management (Full Spec)** cho các tác vụ *"Thêm con"*, *"Thêm vợ/chồng"* và *"Action Form (AF)"*.

Bạn có thể lưu lại bản mô tả kỹ thuật này để chuyển sang Thread mới. Nó sẽ giúp Thread mới hiểu sâu 100% cơ chế vận hành từ **Visual State (React Flow)** đến **Data State (Backend Lines/Draft Payload)** mà không cần phải đoán hay hỏi lại.

# **TÀI LIỆU THUẬT TOÁN CHI TIẾT \- TRẠNG THÁI, CỜ VÀ QUẢN LÝ PAYLOAD (MFO 5L)**

### **I. CÁC CỜ TRẠNG THÁI (FLAGS) VÀ BIẾN QUẢN LÝ TẠI CLIENT**

| Tên Cờ / State Variable | Kiểu Dữ Liệu | Vị Trí / Scope | Ý Nghĩa & Tác Dụng |
| :---- | :---- | :---- | :---- |
| isEmptyNode | Boolean | activeActionNode | Cờ xác định Node đang bấm AF là Box rỗng (Chưa chọn nhân sự Đời) hay Box đã có người. |
| isSolidUnionEdge | Boolean | handleNodeAction | Cờ phân định kiểu đường nối A-1.5: true $\rightarrow$ Nối từ Tab Hôn phối (MÀU CHÀM, NẾT LIỀN); false $\rightarrow$ Nối từ Con chưa gắn (owner:unassigned, MÀU VÀNG, NẾT ĐỨT). |
| hasChildrenAtNextDepth | Boolean | OpMfoPlanPage | Cờ xác định Node cha có con ở Đời $depth+1$ hay không (dựa trên unassignedCount \> 0, childCount \> 0, hoặc tra cứu thành công qua Graph Edge). |
| activeUnionId | String | null | data / AF | ID của Cụm Hôn phối (Tab) đang được NSD chọn active trên Node Card. |
| nodesDraggable | Boolean | \<ReactFlow\> | Cờ toàn cục bật tính năng kéo rê Node ngang trên Canvas (true). |
| draftSet | Object (JSON) | OpMfoPlanPage | Bản sao deep-clone của Payload BFS (JSON.parse(JSON.stringify(fullSet))), chứa toàn bộ trạng thái dữ liệu nháp đồ thị. |
| activeUnionByTreeId | Object (Map) | OpMfoPlanPage | Lưu trữ Map cặp { \[treeId\]: unionId } để duy trì Tab đang active của từng Node khi đồ thị re-build. |

### **II. THUẬT TOÁN CHI TIẾT TÁC VỤ "THÊM VỢ/CHỒNG" (**ADD\_SPOUSE**)**

```

[NSD Bấm 'Thêm vợ/chồng' trên AF]
               │
               ▼
┌────────────────────────────────────────────────────────┐
│ 1. Sinh Union ID Nháp:                                 │
│    newUnionId = "union-draft-" + Date.now()            │
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│ 2. Cập nhật State `nodes`:                             │
│    - Tìm Node target theo `targetNodeId` / `treeId`.   │
│    - Lấy mảng `currentTabs = node.data.tabs || []`.    │
│    - Tạo Tab Nháp mới:                                 │
│      newTab = {                                        │
│        unionId: newUnionId,                            │
│        order: currentTabs.length + 1,                  │
│        status: 'DANG_KET_HON',                         │
│        partnerName: 'Vợ/Chồng (Xin tạo)', // Hiện "XT"  │
│        childCount: 0                                   │
│      }                                                 │
│    - Ép `node.data.activeUnionId = newUnionId`.        │
│    - Ép `node.data.hasPartner = true`.                 │
│    - Cập nhật mảng `tabs: [...currentTabs, newTab]`.   │
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│ 3. Cập nhật Active Map & Render:                       │
│    - `setActiveUnionByTreeId(treeId -> newUnionId)`.   │
│    - Tab mới được active trên UI Card.                 │
│    - Thẻ HTML `<Handle id={"union:" + newUnionId +     │
│      ":children"}>` được Mount vào DOM tại left: 78%.  │
└────────────────────────────────────────────────────────┘

```

### **III. THUẬT TOÁN CHI TIẾT TÁC VỤ "THÊM CON" (**ADD\_CHILD**)**

```

[NSD Bấm 'Thêm con' trên AF]
               │
               ▼
┌────────────────────────────────────────────────────────┐
│ 1. Kiểm tra Giới hạn Đời (Depth Check):               │
│    childDepth = targetDepth + 1.                       │
│    Nếu childDepth > 4 ──► Toast lỗi (Vượt quá 5L) & STOP.│
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│ 2. Khởi tạo Node Con Nháp (New Child Node):            │
│    newChildId = "draft-child-" + Date.now()            │
│    newChildNode = {                                    │
│      id: newChildId,                                   │
│      type: 'familyCouple',                             │
│      position: { x: parentX + 30, y: childDepth * 310},│
│      data: {                                           │
│        id: newChildId, treeId: newChildId,             │
│        depth: childDepth,                              │
│        clanName: 'Con đời ' + childDepth + ' (Xin tạo)',│
│        partnerName: null, unassignedCount: 0, tabs: [] │
│      }                                                 │
│    }                                                   │
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│ 3. Quyết định Handle & Nét vẽ A-1.5:                   │
│    Lấy activeUnionId của Node cha.                      │
│    - Nếu có activeUnionId:                             │
│      sourceHandle = "union:" + activeUnionId + ":children"│
│      isSolidUnionEdge = true                           │
│    - Nếu KHÔNG có activeUnionId:                       │
│      sourceHandle = "owner:unassigned"                 │
│      isSolidUnionEdge = false                          │
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│ 4. Khởi tạo Edge Nháp (New Child Edge):                │
│    newEdge = {                                         │
│      id: "edge-" + targetNodeId + "-" + newChildId,    │
│      type: 'smoothstep',                               │
│      source: targetNodeId, target: newChildId,         │
│      sourceHandle: sourceHandle,                       │
│      style: isSolidUnionEdge                           │
│        ? { stroke: '#6366f1', strokeWidth: 2 }          │
│        : { stroke: '#f59e0b', strokeWidth: 2,          │
│            strokeDasharray: '4 4' }                    │
│    }                                                   │
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│ 5. Micro-Task Mounting (Tránh rớt Edge):                │
│    - Gọi `setNodes(prev => [...prev, newChildNode])`.  │
│    - Chờ DOM Mount Handle nhịp kế tiếp bằng:           │
│      `requestAnimationFrame(() =>                      │
│         setEdges(prev => [...prev, newEdge])           │
│       )`.                                              │
└────────────────────────────────────────────────────────┘

```

### **IV. THUẬT TOÁN TRA CỨU CON QUA ĐỒ THỊ (GRAPH EDGE CHILD LOOKUP)**

Vấn đề: Node cha chỉ chứa chỉ số unassignedCount chứ **không lưu tên đứa con chưa gắn hôn phối** (Adapter đưa con thành Node riêng nối bằng Edge).

**Thuật toán Tra cứu tên con trên Canvas:**

JavaScript

```

// Input: activeNodeId (Node cha đang mở AF), mảng `edges`, mảng `nodes`
let foundChildName = activeActionNode?.childFullName || null;

if (!foundChildName && activeNodeId) {
  // Bước 1: Ưu tiên tìm Edge xuất phát từ owner:unassigned (Con chưa gắn hôn phối)
  const unassignedEdge = edges.find(
    (e) => e.source === activeNodeId && e.sourceHandle === 'owner:unassigned'
  );
  if (unassignedEdge) {
    const childNode = nodes.find((n) => n.id === unassignedEdge.target);
    foundChildName = childNode?.data?.clanName || childNode?.data?.clan?.full_name || null;
  }

  // Bước 2: Nếu không có, tìm Edge xuất phát từ Handle của Tab Hôn phối active
  if (!foundChildName && activeActionNode?.activeUnionId) {
    const unionEdge = edges.find(
      (e) =>
        e.source === activeNodeId &&
        e.sourceHandle === `union:${activeActionNode.activeUnionId}:children`
    );
    if (unionEdge) {
      const childNode = nodes.find((n) => n.id === unionEdge.target);
      foundChildName = childNode?.data?.clanName || childNode?.data?.clan?.full_name || null;
    }
  }
}

// OutPut render lên Phần 1 AF:
// - Nếu `foundChildName != null`: "Thông tin hôn nhân: Các con đời dưới như: {foundChildName} thiếu khai báo cha/mẹ"
// - Nếu `foundChildName == null`: "Thông tin hôn nhân: Chưa khai báo."

```

### **V. THUẬT TOÁN MỞ RỘNG CHO PHA 2: DONG GÓI DRAFT PAYLOAD KHI SUBMIT**

Hiện tại trên Canvas, mọi thao tác nháp nằm ở nodes và edges của React Flow. Để gửi Tờ trình 5L lên Backend qua API createPlan() khi bấm **"Trình Khung 5L"**, thuật toán đóng gói Payload (Draft Serialization) sẽ thực hiện theo các bước:

```

[NSD Bấm "Trình Khung 5L"]
               │
               ▼
┌────────────────────────────────────────────────────────┐
│ 1. Thu thập Lines Nguyên thủy:                         │
│    Lấy mảng `lines` (0 đến 4) từ state trang.          │
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│ 2. Quét mảng `nodes` để đóng gói Cluster / Sub-tree:    │
│    Lặp qua từng node trong `nodes`:                    │
│    - Nếu là Node nháp (`id.startsWith('draft-child-')`):│
│      Ghi nhận thuộc tính con nháp: op: 'ADD_CHILD',    │
│      depth: node.data.depth, parent_node_id: ...     │
│    - Nếu Node có Tab nháp (`unionId.startsWith('union-draft-')`):│
│      Ghi nhận cụm hôn phối nháp: op: 'ADD_SPOUSE',     │
│      partner_name: 'Vợ/Chồng (Xin tạo)'                │
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│ 3. Chuyển đổi thành JSON Sanitized Lines:              │
│    Gọi `sanitizeLines(linesWithDrafts, { originId, k })│
│    để lọc bỏ các trường đồ họa thuần túy (x, y, rect). │
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│ 4. Gọi API Submit Backend:                             │
│    `createPlan({                                       │
│       origin_member_id: effectiveOriginId,             │
│       k: parsedK,                                      │
│       lines: sanitizedDraftLines                       │
│     })`                                                │
└────────────────────────────────────────────────────────┘

```

### **VI. NỘI DUNG MỞ ĐẦU CHO THREAD MỚI (COPY & PASTE SANG THREAD MỚI)**

Bạn chỉ cần sao chép toàn bộ đoạn dưới đây và dán vào Thread mới:

**Gửi AI Thread Mới:**  
Tôi đang phát triển tính năng **MFO 5-Lanes Genealogy Planner** (Tạo khung tờ trình phả hệ 5 đời từ Đời 0 đến Đời 4).

Hãy đọc kỹ **Tài liệu Thuật toán Chi tiết: Trạng thái, Cờ và Quản lý Payload (MFO 5L)** bên trên.

**Mã nguồn cơ sở đã UAT thành công Pha 1:**

1. frontend/src/features/genealogy/components/FamilyCoupleNode.jsx (v2.2.1-A15-ANCHOR-SPACE-DRAGGABLE-READY)  
2.   
3. frontend/src/pages/OpMfoPlanPage.jsx (v1.4.34-GRAPH-EDGE-CHILD-LOOKUP)  
4. 

**Các quy chuẩn cốt lõi bắt buộc tuân thủ:**

* Không dùng Dagre. Khóa cứng $Y=depth\times 310px$ trên onNodeDragStop (chỉ cho kéo ngang $X$).  
*   
* Edge A-1.5: Con của Tab hôn phối active $\rightarrow$ Nối từ Handle tím \$78\\%\$ (stroke: '\#6366f1', nét liền); Con chưa gắn $\rightarrow$ Nối từ Handle vàng \$22\\%\$ (stroke: '\#f59e0b', nét đứt).  
*   
* Micro-task Edge Mounting: Dùng requestAnimationFrame để hoãn setEdges 1 frame sau setNodes nhằm chờ Handle mount DOM.  
*   
* Phần 1 AF: Tra cứu tên con đời dưới ($depth+1$) qua mảng edges đồ thị. Render đúng 2 trường hợp:  
* 

  * *Trường hợp a*: Thông tin hôn nhân: Các con đời dưới như: {childFullName} thiếu khai báo cha/mẹ  
  *   
  * *Trường hợp b*: Thông tin hôn nhân: Chưa khai báo.  
  *   
* Hậu tố (Xin tạo) sinh Avatar chữ viết tắt **"XT"**.  
* 

Bạn đã nắm rõ toàn bộ thuật toán, cờ trạng thái và sơ đồ luồng dữ liệu trên chưa? Hãy xác nhận để chúng ta tiến hành công việc tiếp theo\!

