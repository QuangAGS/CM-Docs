# **BẢN PHẢN BIỆN KỸ THUẬT & ĐỐI CHIẾU KIẾN TRÚC: MODULE MFO FRONTEND (MYCLAN)**

**Tài liệu tham chiếu SSOT:**

* BFA-Branch-Family-Doctrine-v1.3.1.md  
* BFA-MFO-Lot-Ops-v1.0.md  
* HandOver-MFO-L1-L10-2026-09-20.md

## **1\. Đánh giá quy trình làm việc & Phương pháp tiếp cận của Perplexity**

### **1.1. Điểm hợp lý**

* **Tính cẩn trọng về bảo mật & tài nguyên:** Nhận biết và yêu cầu loại bỏ node\_modules, .env, binary secrets, dump database thật trước khi gửi context.  
* **Quy trình 2 bước (Khung sườn trước \- Chi tiết sau):** Đề xuất đưa ra khung tài liệu để chốt mục tiêu và phạm vi trước khi viết mã nguồn hoặc tài liệu đặc tả chi tiết.

### **1.2. Điểm yếu, Sai lệch ngữ cảnh & Nguy cơ "Over-Engineering"**

| Vấn đề | Phân tích thực tế trong dự án | Rủi ro kỹ thuật |
| :---- | :---- | :---- |
| **Đòi hỏi tải quá nhiều module không liên quan** | Yêu cầu cả features/genealogy, elder-doctrine, onboarding, auth, tenants, v.v. Trong khi hiện tại dự án đang ở **Pha Cây người từ MFO / 5L**, các nhánh RP/OP/SM đã **CLOSED**. | Làm loãng context, dễ dẫn đến việc AI đề xuất sửa đổi các module đã đóng băng, vi phạm nguyên tắc Q1 (Bảo toàn máy đã live). |
| **Nhầm lẫn cơ chế dữ liệu MFO (Nghi ngờ có temp\_data)** | Câu hỏi *"temp\_data nằm ở đâu, Member/Marriage có bị tạo trước result approved không?"* cho thấy Perplexity đang suy diễn mô hình staging nháp tách biệt (shadow tables). | **Sai lệch SSOT BFA-MFO-Lot-Ops v1.0:** Khi có plan\_ok, POST /api/mfo/plans/:id/members ghi **trực tiếp vào bảng members**, không có bảng tạm. Nghiệm thu RESULT là chốt kết quả, không phải lúc insert DB. |
| **Quá tải về tài liệu hóa (Documentation bloat)** | Vẽ ra quá nhiều tầng tài liệu trước khi bắt tay vào giải quyết bài toán UI/UX của form 5L. | Gây chậm tiến độ. Bản chất FE MFO lúc này cần tập trung vào: Flow chọn Origin ![][image1] Tính ![][image2] ![][image1] Bảng 5L ![][image1] Form người ![][image1] Submit Result. |

## **2\. Giải đáp & Bóc tách 5 câu hỏi kỹ thuật trọng tâm của Perplexity**

### **Câu hỏi 1: "Plan và plan data có persist không?"**

* **Thực tế hệ thống:** **CÓ**.  
* **Cơ chế lưu trữ:**  
  * Bảng proposals (ticket): Lưu phiếu trình duyệt với ticket\_type \= 'MFO\_REVIEW' (hoặc lô cũ BRANCH\_REVIEW \+ kind \= 'PLAN').  
  * target\_table \= 'members', target\_id \= origin\_member\_id.  
  * Khung 5L nằm trong proposals.payload: lines\[\] (gồm 5 phần tử line: 0..4, op: ASSIGN|CREATE|EMPTY, member\_id, hint), k, origin\_member\_id.  
  * Khi Admin duyệt, granted\_generation được ghi nhận trực tiếp vào payload/note của proposal.

### **Câu hỏi 2: "plan\_ok có khóa topology ở backend không?"**

* **Thực tế hệ thống:** **KHÓA ĐỜI (LINE), KHÔNG NIÊM PHONG FIELD.**  
* **Quy tắc cứng:**  
  * Dòng nào đánh dấu EMPTY: Backend chặn 422 nếu client cố tình gọi POST /members vào dòng đó.  
  * Dòng ![][image2]: Bắt buộc ASSIGN Founder. Nếu ![][image3], sau khi có plan\_ok chỉ được tạo **anh/em** của Founder (POST /members "line": k), không được ghi đè Founder.  
  * **Không niêm phong field:** Sau khi có plan\_ok và thậm chí sau cả RESULT APPROVED, hệ thống vẫn cho phép PATCH /members/:id (sửa thông tin người đã tạo trong lô), PATCH /founder (gán cha mẹ cho founder), và POST /spouses (gắn hôn nhân). Tuyệt đối **không được tạo đời mới ngoài 5L đã tem**.

### **Câu hỏi 3: "temp\_data nằm ở đâu? Member/Marriage có bị tạo trước result approved không?"**

* **Thực tế hệ thống:** **KHÔNG CÓ TEMP\_DATA. DỮ LIỆU ĐƯỢC TẠO THẬT TRƯỚC RESULT APPROVED.**  
* **Nguyên lý cốt lõi (Xem §3 & §5 BFA-MFO-Lot-Ops-v1.0):**  
  1. Sau khi nhận tem plan\_ok, người dùng gọi POST /api/mfo/plans/:id/members ![][image1] Một record thật được tạo ngay lập tức trong bảng members và ID được gom vào mảng created\_member\_ids của lô.  
  2. Tương tự, POST /api/mfo/plans/:id/spouses tạo trực tiếp bản ghi trong bảng marriages.  
  3. POST /api/mfo/plans/:id/result: Chỉ đóng vai trò **nộp báo cáo nghiệm thu**.  
  4. POST /result/approve: Admin đóng dấu nghiệm thu lô.  
* **Lưu ý cảnh báo:** Nếu FE xây dựng theo hướng gom toàn bộ data vào LocalStorage/State rồi chờ Admin duyệt RESULT mới đẩy DB là **hoàn toàn sai kiến trúc backend đã live**.

### **Câu hỏi 4: "Business / Communication Ledger được dùng thế nào?"**

* **BPL (Business Process Logs):**  
  * Tách biệt khỏi Chi. Sử dụng bộ 17 nhãn Enum riêng MFO\_\* (như MFO\_PLAN\_SUBMIT, MFO\_PLAN\_APPROVE, MFO\_MEMBER\_CREATE, MFO\_SPOUSE\_ATTACH, MFO\_RESULT\_SUBMIT, v.v.).  
  * Cơ chế attempt\_no tự tăng theo correlation\_id của ticket qua SQL sống.  
* **Communication Ledger:**  
  * Hoạt động theo mô hình silentEmit. Lỗi thông báo không được phép làm rollback giao dịch nghiệp vụ.  
  * Phía FE không cần can thiệp trực tiếp vào bảng ledger, chỉ cần quan tâm mã lỗi chuẩn (ví dụ: 409 MFO\_MEMBER\_DUP, 422 MFO\_K\_MUST\_ASSIGN\_FOUNDER).

### **Câu hỏi 5: "Message orchestration và Voice đối chiếu với các page MFO thế nào?"**

* **Giọng văn (Elder Doctrine):** Xưng hô trang trọng ("bác", "cháu"), không đưa các mã enum thô kệch (5L\_PLAN\_OK, BRANCH\_REVIEW) ra giao diện cho người dùng đọc.  
* **VoiceHelp:** Đóng vai trò là tài liệu UX / Tooltip / Hướng dẫn điền form (đặc biệt là cách điền con nuôi, dâu, rể ở child\_type \+ Note, chứ không tính vào đếm đời huyết thống).

## **3\. Kiến trúc Frontend (FE) chuẩn xác cho MFO**

Để phát triển FE MFO gọn gàng, đúng nghiệp vụ và không bị phình to kiến trúc, hệ thống FE cần phân bổ theo 4 khối màn hình chính:

\[MFO Module Frontend\]  
 ├── 1\. MFO Dashboard & Quản lý Ticket (Danh sách Lô của tôi / Tenant)  
 ├── 2\. MFO Wizard Lập Kế Hoạch (Tạo PLAN \- Khung 5L)  
 │     ├── Chọn Origin (Dòng 0\) \-\> Auto tính k & Render nhánh cây  
 │     └── Thiết lập 5 dòng (ASSIGN / CREATE / EMPTY)  
 ├── 3\. MFO Workbench (Không gian thực thi sau khi nhận tem plan\_ok)  
 │     ├── Cây phác thảo 5L thời gian thực (Interactive Tree View)  
 │     ├── Form thêm thành viên (POST /members theo Line được phép)  
 │     ├── Form gắn Hôn nhân (POST /spouses)  
 │     ├── Thao tác nối Founder (link\_as: FATHER | MOTHER)  
 │     └── Nút nộp nghiệm thu (POST /result)  
 └── 4\. MFO Admin Review Modal (Duyệt Plan / Trả Plan / Nghiệm thu Result)

### **3.1. Các quy tắc FE Form bắt buộc phải Validate Client-side**

1. **Kiểm tra ![][image2]:** Nếu người dùng chọn Origin mà thuật toán tính ra ![][image4], lập tức vô hiệu hóa nút Submit và hiển thị thông báo: *"Origin cách quá 4 đời huyết thống. Vui lòng chọn cụ/ông gần hơn hoặc tạo nhánh nối tiếp."*  
2. **Khung một người (Member Form):**  
   * Trường bắt buộc: line (1..4), full\_name (tự động trim), gender (NAM | NU | KHAC).  
   * Ràng buộc nội tộc: Phải có ít nhất 1 trong 2: father\_id hoặc mother\_id (Ngoại trừ Dòng ![][image2] khi để trống sẽ tự clone từ Founder).  
   * Cảnh báo trùng sổ trước khi submit: Cảnh báo nếu trùng tên \+ năm sinh \+ cha/mẹ với dữ liệu trên cây.  
3. **Cấm A01:** Form PATCH người tuyệt đối không hiển thị các trường chỉnh sửa: Giới tính, Tình trạng còn sống/đã mất, SĐT, Email.

[image1]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABoAAAAfCAYAAAD5h919AAAAoklEQVR4Xu2RMQoCMRQFY6+daVIkpkrhSbT1Bl5NPIE3sPAAnkFQsbYRYZ00Fg+s/CnEDDwWJgtDdp3rdDr/Q0ppqa4JhLZspd4c7/2Y0FN9EwhdY4xz9U0gNvAYqTenlDKpsRno2RvOjrx0NtiNDezuPtyuyq9HYMMeOefiWkHgwJfZqzeFyJqd1JtT/4s6c4gs2E69OUQuIYSp+k6n88O8AIPMMCJp/cwiAAAAAElFTkSuQmCC>

[image2]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAgCAYAAAAi7kmXAAABHklEQVR4XmNgGAXEAXl5+e1AfB+I/wPxF3R5XIBZTk6uH6jhN1RjH7oCvACo4RVIo5SUlAi6HF4Ate0/ujghwESWRqCGYpAmoF9noMvhBUBNH6A2SsLEZGRkOIH8O0D8R0lJiR9ZPRygOxNocyyQ/xAqtwWIXyFUIwCK/4B0iYKCQieU/RMq9wRVCxAAFRVCJecB2ROAtpUhyU0EyQFpAWQ9YACUeA+zEagpBl0eJ4BpAtkIYwNtaEBXhw5g/vsHE4C5ABiq0sgKUQBQQQ5U4xQksVaorelQvhEQr0foggg+BSlSVlYWg4kB/bkTJCYrKysFVXMTIx6htqEkM6DGfKhThVRUVNiB7B/I8mAA1bgfi/hZqNxfdLlRMArIAwApGWFIY7HkmAAAAABJRU5ErkJggg==>

[image3]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAD0AAAAgCAYAAAChKnCsAAACcElEQVR4Xu2XS0iUURTH1cEem7QHgvP65tVmlg0EbtwKLqNV5rqNIKEotHLTQsRKcSEEs4ygICm1x0aCFm7apwYW2EJdqKik+PyfPNeuhxnsu/cOhN4fHOb7zv887pl7v2+0qsrj8XjOEkEQvIfNww5gG1I/i0SSyeRTDLvDQz+RASGoSaVS9dJZSbD2q1jzOuyN1E4FSUs0dDQavSG1EFSjxjJsD9YkRVeg9nPYb94kZUZD/0mWfhPy+fwF7Pgs17wndVuwu3dRtxWXEfQZMh26xuXQOqj5hepioT1Sc4Hx0Ejo4oWNSs0VqP+KetAipWaDzdCrnNiofPF4/DLuv8N2M5lMnR5vA+oNc6/XUjPBZmhKOj7a2PF23P9kbRy29DfaDaj5iHqi12ephcF06BPPMz67Uaifr7dZWziZ4g7Unla9TVBD48sbk1pZkPSQByvi+pn+wlEFUxX47UXdQe5rdcy1Nb6VWlmQsMLN6du6L3XXoM8L7jcsNRO04/1OamVRA8OK6hqF+mScLag7RbXxxfZKzQZt6AmplUM9z/vKEfDO4+0d0wNNKBQKtaj1jXu0Sd0F2tCTUisJAjs4YUTzPSYfij3g+1tByDdjLpe7gpxFqpNOp5ul7hI1NE7QB6mVBMG/KCGbzTYoH5I/ki+RSEQ5ZuZff6exgEuIX4Nt46TclHol0F5kn6RWEgom030YupN8WPQ17NhFXG/p+ilUU550uoYePZyg2xi0JeB/lGCbsDvB0clMy5xjOHiqhP8ra3tS+x/AugZ42B/B0V+Nc/xJ94vYuJcyx+OxJBaLXefHIrTJWh6Px+PxnGMOAU1F50bt+DeCAAAAAElFTkSuQmCC>

[image4]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAD0AAAAgCAYAAAChKnCsAAACh0lEQVR4Xu2Wu0tcURDGfSJiwFfWTfZ19oWFZRYClpImTSB/QLQVjCCiWNso2PgAixDELmARsBEkjYJaJaSzkSQEiRaKoIgQxec3e+fq2WHXu/fe3WLl/GDYe+abOefM7pmzt6rKYDAYnhJKqVXYX9gt7EzqlUI8Hn+bSCSC0p+P2lgsNoNiL7noaRlQCYTD4XbaP2rplVpBkHBISaFQ6LnUKgH+wVwXnU2S/koA+/7ipeiaUhSNBZO88KTUygXWasWaN7A1V0UjeIQTPknNC7hQxvlL/Cq1UkPrBAKBZ16KPuFNvrR9kUikEePfsKtkMtmsxxcLcgdoXnwJ3zGslrpfMPdnMn52XTQVfH+0KRHjXdZWYIcP0e5B0e95jX/BYLBJ6l6gefQ9uy06p5/xOYpNTvHzBWt7uSnewH/oa2X13xlOUljqbsAc19TP2rj4olHgMBe2iOdZJI1p2hxp+GzRc/zCF9457ArPXVJ3gi5K2JLuc1U0Ao+5aEr4IPVywjfvEa0ttUJkMpn6fPFui84WDFu0n+n2lXGlhntyjzf6TuqFUFbLdeMNLEKvnOl0OkAG3xbv/yONHzuddj/f2A7Fv7zfnisENvMC85/SmtTjUneC91uMbcrcLBAGOWBe802QD5vr5/Er2PJDljeod5X1fv8fc8el7he7WMfjjaB9CkylUh22D0nfyBeNRkMcs+P1f5rAfG94Qwd+5nFCK7pPajnYgboPSUPkw/FuQ2804Plc14uFLkWefxvDOqmXCqyToTvBrgX2A9aDL7hTxmbhoPU8/p+sXUvNCcUtQydGauVAWW+Tu8p6e/wF+wPbRwdtyNiyQJcfFlyQfoPBYDAYDAZDHu4AP3TqGPColC0AAAAASUVORK5CYII=>