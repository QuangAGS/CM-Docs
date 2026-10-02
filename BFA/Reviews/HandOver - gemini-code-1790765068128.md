### HANDOVER CONTEXT: DỰ ÁN GENEALOGY MFO 5-LINE (5L) VIEW

1. **MỤC TIÊU NGHIỆP VỤ (SSOT)**:
- Hiển thị và xử lý Tờ trình Khung 5 Đời (5L View) cho thành viên M bất kỳ được chọn ở Dòng k (k = 0..4).
- Đời 0 (Origin) của Tờ trình phải là Tổ tiên cao nhất (Line 0 Ancestor) thu được sau khi lùi Thượng đúng k bước từ target member M, tuyệt đối không gán ép M làm Origin khi k > 0.
- Bảo toàn tuyệt đối nguyên tắc "Cha Mẹ ở đâu, Con theo đó" (Standard Tree ST(D) Clusters) và sắp xếp anh/chị/em chuẩn 100% theo `sibling_seq` từ trái qua phải.

2. **TIẾN ĐỘ VÀ KIẾN TRÚC ĐÃ HOÀN THÀNH**:
- **Backend (`mfo.service.js`)**: Đã nâng cấp hàm `getFullMfoSet({ user, originId, k })` để:
  + Nhận `originId` (chính là memberId M) và `k` (selectedDepth).
  + Lùi Thượng đúng k bước xác định `rootNode` (Đời 0) và tính `actualAncestorSteps` / `rootDepth`.
  + Trả về cấu trúc 5 Đời cố định (`levels[0..4]`), trong đó mỗi level chứa `nodes` và `standard_trees` (ST clusters bao gồm parent anchor + partners + sorted children + child partners).
- **Backend (`mfo.controller.js` & `mfo.routes.js`)**: Đã hỗ trợ route `GET /api/mfo/origins/:originId/full-set?k=:k` và truyền `req.query.k` vào Service.
- **Frontend (`mfoApi.js`)**: Hàm `getFullMfoSet(originId, k)` đã gửi query `?k=${k}`.

3. **VIỆC CẦN LÀM NGHĨA VỤ TẠI THREAD MỚI**:
- Hoàn thiện tệp `frontend/src/shared/services/genealogyViewFocusService.js` (hàm `fulfillViewFocus5L`) để bọc try-catch/null-safe an toàn tuyệt đối khi đọc trực tiếp `levels` và `standard_trees` từ Backend payload, tránh crash React Tree (trắng trang).
- Đảm bảo `OpMfoPlanPage.jsx` khi submit lấy đúng `origin_member_id` là Đời 0 (`treeData.origin.id` hoặc `lines[0].member_id`).
- Tiến hành kiểm thử toàn diện gán M ở các Đời k khác nhau (k = 0, 1, 2, 3, 4) và kiểm tra lại FanConnector vẽ đường nối giữa các cụm ST.