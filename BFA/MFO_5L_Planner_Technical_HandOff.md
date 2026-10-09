**MFO 5-LANES GENEALOGY PLANNER**

**TÀI LIỆU HANDOFF KỸ THUẬT & QUY CÁCH DỰ ÁN (PHA 1\)**

| Dự án: MFO Genealogy Planner (Management of Family Origins) Phân hệ: Action Form (AF) & Căn chỉnh Đồ thị 5L (5-Generational Lanes Canvas) Trạng thái: Hoàn thành 100% UAT Pha 1 (Tạo khung trình 5L) Ngày lập: 03/10/2026 |
| :---- |

 

**I. MÃ NGUỒN CƠ SỞ ĐÃ UAT THÀNH CÔNG**

**1\. frontend/src/features/genealogy/components/FamilyCoupleNode.jsx**

**·**       **Version: 2.2.1-A15-ANCHOR-SPACE-DRAGGABLE-READY**

**·**       **Chức năng: Custom React Flow Node đại diện cho Cụm Hôn phối (1 Owner \+ N Tabs Vợ/Chồng), Handles đa điểm (22% & 78%), Avatar 'XT' cho nhân sự nháp mới tạo.**

**2\. frontend/src/pages/OpMfoPlanPage.jsx**

**·**       **Version: 1.4.34-GRAPH-EDGE-CHILD-LOOKUP**

**·**       **Chức năng: Quản lý Canvas React Flow 5L, khống chế tọa độ Y theo tầng Đời, tra cứu tên con trực tiếp qua Graph Edges, render Action Form Portal.**

**II. CÁC BẢNG CỜ TRẠNG THÁI (FLAGS) & BẢN BỒI DỮ LIỆU**

| Tên Cờ / Variable | Kiểu Dữ Liệu | Vị Trí / Scope | Ý Nghĩa & Tác Dụng |
| :---- | :---- | :---- | :---- |
| **isEmptyNode** | **Boolean** | **activeActionNode** | **Bật true khi người dùng bấm vào ô rỗng chưa chọn nhân sự Đời.** |
| **isSolidUnionEdge** | **Boolean** | **handleNodeAction** | **Phân định kiểu nét vẽ A-1.5 (true: nét liền màu chàm; false: nét đứt màu vàng).** |
| **hasChildrenAtNextDepth** | **Boolean** | **OpMfoPlanPage** | **Xác định Node cha có con ở Đời depth \+ 1 hay không để phân nhánh thông điệp.** |
| **activeUnionId** | **String | null** | **data / AF** | **ID của Tab Hôn phối đang được chọn active trên Node Card.** |
| **nodesDraggable** | **Boolean** | **\<ReactFlow\>** | **Bật tính năng kéo rê Node ngang trên Canvas (true).** |
| **draftSet** | **Object (JSON)** | **OpMfoPlanPage** | **Bản sao deep-clone của Payload BFS (JSON.parse(JSON.stringify(fullSet))).** |
| **activeUnionByTreeId** | **Object (Map)** | **OpMfoPlanPage** | **Map lưu cặp {\[treeId\]: unionId} duy trì Tab active khi graph re-build.** |

 

**III. THUẬT TOÁN XỬ LÝ CHI TIẾT**

**1\. Thuật toán Tác vụ 'Thêm vợ/chồng' (ADD\_SPOUSE)**

| \[NSD Bấm 'Thêm vợ/chồng' trên AF\]            	│            	▼ ┌────────────────────────────────────────────────────────┐ │ 1\. Sinh Union ID Nháp:                             	│ │	newUnionId \= "union-draft-" \+ Date.now()        	│ └──────────────────────────┬─────────────────────────────┘                        	│                        	▼ ┌────────────────────────────────────────────────────────┐ │ 2\. Cập nhật State \`nodes\`:                         	│ │	\- Tìm Node target theo \`targetNodeId\` / \`treeId\`.   │ │	\- Lấy mảng \`currentTabs \= node.data.tabs || \[\]\`.	│ │	\- Tạo Tab Nháp mới:                             	│ │  	newTab \= {                                    	│ │    	unionId: newUnionId,                        	│ │    	order: currentTabs.length \+ 1,              	│ │    	status: 'DANG\_KET\_HON',                     	│ │    	partnerName: 'Vợ/Chồng (Xin tạo)', // Hiện "XT" │ │    	childCount: 0                               	│ │  	}                                                 │ │	\- Ép \`node.data.activeUnionId \= newUnionId\`.    	│ │	\- Ép \`node.data.hasPartner \= true\`.             	│ │	\- Cập nhật mảng \`tabs: \[...currentTabs, newTab\]\`.   │ └──────────────────────────┬─────────────────────────────┘                        	│                        	▼ ┌────────────────────────────────────────────────────────┐ │ 3\. Cập nhật Active Map & Render:                   	│ │	\- \`setActiveUnionByTreeId(treeId \-\> newUnionId)\`.   │ │	\- Tab mới được active trên UI Card.             	│ │	\- Thẻ HTML \`\<Handle id=union:\<id\>:children\>\`        │ │  	được Mount vào DOM tại left: 78%.             	│ └────────────────────────────────────────────────────────┘ |
| :---- |

 

**2\. Thuật toán Tác vụ 'Thêm con' (ADD\_CHILD)**

| \[NSD Bấm 'Thêm con' trên AF\]            	│            	▼ ┌────────────────────────────────────────────────────────┐ │ 1\. Kiểm tra Giới hạn Đời (Depth Check):           	│ │	childDepth \= targetDepth \+ 1\.                   	│ │	Nếu childDepth \> 4 ──► Toast lỗi (Vượt quá 5L) & STOP.│ └──────────────────────────┬─────────────────────────────┘                        	│                        	▼ ┌────────────────────────────────────────────────────────┐ │ 2\. Khởi tạo Node Con Nháp (New Child Node):        	│ │	newChildId \= "draft-child-" \+ Date.now()        	│ │	newChildNode \= {                                	│ │  	id: newChildId, type: 'familyCouple',         	│ │  	position: { x: parentX \+ 30, y: childDepth \* 310},│ │  	data: {                                       	│ │    	id: newChildId, treeId: newChildId,         	│ │    	depth: childDepth,                          	│ │    	clanName: 'Con đời ' \+ childDepth \+ ' (Xin tạo)',│ │    	partnerName: null, unassignedCount: 0, tabs: \[\] │ │  	}                                                 │ │	}                                                   │ └──────────────────────────┬─────────────────────────────┘                        	│                        	▼ ┌────────────────────────────────────────────────────────┐ │ 3\. Quyết định Handle & Nét vẽ A-1.5:               	│ │	Lấy activeUnionId của Node cha.                  	│ │	\- Nếu có activeUnionId:                         	│ │  	sourceHandle \= "union:" \+ activeUnionId \+ ":children"│ │  	isSolidUnionEdge \= true                       	│ │	\- Nếu KHÔNG có activeUnionId:                   	│ │  	sourceHandle \= "owner:unassigned"                 │ │  	isSolidUnionEdge \= false                      	│ └──────────────────────────┬─────────────────────────────┘                        	│                        	▼ ┌────────────────────────────────────────────────────────┐ │ 4\. Khởi tạo Edge Nháp (New Child Edge):            	│ │	newEdge \= {                                     	│ │  	id: "edge-" \+ targetNodeId \+ "-" \+ newChildId,    │ │  	type: 'smoothstep',                           	│ │  	source: targetNodeId, target: newChildId,     	│ │  	sourceHandle: sourceHandle,                   	│ │  	style: isSolidUnionEdge                       	│ │    	? { stroke: '\#6366f1', strokeWidth: 2 }      	│ │    	: { stroke: '\#f59e0b', strokeWidth: 2,      	│ │        	strokeDasharray: '4 4' }                	│ │	}                                                   │ └──────────────────────────┬─────────────────────────────┘                        	│                        	▼ ┌────────────────────────────────────────────────────────┐ │ 5\. Micro-Task Mounting (Tránh rớt Edge):            	│ │	\- Gọi \`setNodes(prev \=\> \[...prev, newChildNode\])\`.  │ │	\- Chờ DOM Mount Handle nhịp kế tiếp bằng:       	│ │  	\`requestAnimationFrame(() \=\>                  	│ │     	setEdges(prev \=\> \[...prev, newEdge\])       	│ │   	)\`.                                              │ └────────────────────────────────────────────────────────┘ |
| :---- |

 

**3\. Thuật toán Tra cứu Tên con qua Graph Edge (Child Lookup)**

| // Input: activeNodeId (Node cha đang bấm AF), mảng \`edges\`, mảng \`nodes\` let foundChildName \= activeActionNode?.childFullName || null; if (\!foundChildName && activeNodeId) {   // Bước 1: Ưu tiên tìm Edge xuất phát từ owner:unassigned (Con chưa gắn hôn phối)   const unassignedEdge \= edges.find( 	(e) \=\> e.source \=== activeNodeId && e.sourceHandle \=== 'owner:unassigned'   );   if (unassignedEdge) { 	const childNode \= nodes.find((n) \=\> n.id \=== unassignedEdge.target); 	foundChildName \= childNode?.data?.clanName || childNode?.data?.clan?.full\_name || null;   }   // Bước 2: Nếu không có, tìm Edge xuất phát từ Handle của Tab Hôn phối active   if (\!foundChildName && activeActionNode?.activeUnionId) { 	const unionEdge \= edges.find(   	(e) \=\>     	e.source \=== activeNodeId &&     	e.sourceHandle \=== \`union:\${activeActionNode.activeUnionId}:children\` 	); 	if (unionEdge) {   	const childNode \= nodes.find((n) \=\> n.id \=== unionEdge.target);   	foundChildName \= childNode?.data?.clanName || childNode?.data?.clan?.full\_name || null; 	}   } } |
| :---- |

 

**IV. QUY TRÌNH MỞ RỘNG CHO PHA 2: ĐÓNG GÓI DRAFT PAYLOAD (SUBMIT)**

| \[NSD Bấm "Trình Khung 5L"\]            	│            	▼ ┌────────────────────────────────────────────────────────┐ │ 1\. Thu thập Lines Nguyên thủy:                     	│ │	Lấy mảng \`lines\` (0 đến 4\) từ state trang.      	│ └──────────────────────────┬─────────────────────────────┘                        	│                        	▼ ┌────────────────────────────────────────────────────────┐ │ 2\. Quét mảng \`nodes\` đóng gói Cluster / Sub-tree: 	│ │	Lặp qua từng node trong \`nodes\`:                	│ │	\- Nếu Node nháp (\`id.startsWith('draft-child-')\`):  │ │  	op: 'ADD\_CHILD', depth, parent\_node\_id...     	│ │	\- Nếu Node có Tab nháp                          	│ │      (\`unionId.startsWith('union-draft-')\`):       	│ │  	op: 'ADD\_SPOUSE', partner\_name...             	│ └──────────────────────────┬─────────────────────────────┘                        	│                        	▼ ┌────────────────────────────────────────────────────────┐ │ 3\. Lọc bỏ thuộc tính đồ họa (Sanitize):            	│ │	Gọi \`sanitizeLines(linesWithDrafts, { originId, k })│ │	lọc bỏ x, y, rect.                              	│ └──────────────────────────┬─────────────────────────────┘                        	│                        	▼ ┌────────────────────────────────────────────────────────┐ │ 4\. Gọi API Submit Backend:                         	│ │	\`createPlan({ origin\_member\_id, k, lines })\`    	│ └──────────────────────────┬─────────────────────────────┘ |
| :---- |

 

**V. PROMPT MỞ ĐẦU CHO THREAD MỚI (COPY & PASTE)**

| Gửi AI Thread Mới: Tôi đang phát triển tính năng MFO 5-Lanes Genealogy Planner (Tạo khung tờ trình phả hệ 5 đời từ Đời 0 đến Đời 4). Hãy đọc kỹ tài liệu HandOff kỹ thuật MFO 5L Planner. Mã nguồn cơ sở đã UAT thành công Pha 1: 1\. frontend/src/features/genealogy/components/FamilyCoupleNode.jsx (v2.2.1-A15-ANCHOR-SPACE-DRAGGABLE-READY) 2\. frontend/src/pages/OpMfoPlanPage.jsx (v1.4.34-GRAPH-EDGE-CHILD-LOOKUP) Các quy chuẩn cốt lõi bắt buộc tuân thủ: \- Không dùng Dagre. Khóa cứng Y \= depth \* 310px trên onNodeDragStop (chỉ cho kéo ngang X). \- Edge A-1.5: Con của Tab active \-\> Handle tím 78% (stroke: '\#6366f1', nét liền); Con chưa gắn \-\> Handle vàng 22% (stroke: '\#f59e0b', nét đứt). \- Micro-task Edge Mounting: Dùng requestAnimationFrame hoãn setEdges 1 frame sau setNodes để chờ Handle mount DOM. \- Phần 1 AF: Tra cứu tên con đời dưới (depth \+ 1\) qua mảng edges đồ thị. Render đúng 2 trường hợp:   \+ Trường hợp a: "Thông tin hôn nhân: Các con đời dưới như: {childFullName} thiếu khai báo cha/mẹ"   \+ Trường hợp b: "Thông tin hôn nhân: Chưa khai báo." \- Hậu tố "(Xin tạo)" sinh Avatar chữ viết tắt "XT". Bạn đã nắm rõ toàn bộ thuật toán, cờ trạng thái và sơ đồ luồng dữ liệu trên chưa? Hãy xác nhận để chúng ta tiến hành công việc tiếp theo\! |
| :---- |

 

