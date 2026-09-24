# **ĐÁNH GIÁ ĐỒNG THUẬN & BLUEPRINT KỸ THUẬT FE MFO (MYCLAN)**

**Tài liệu tham chiếu SSOT:**

* BFA-Branch-Family-Doctrine-v1.3.1.md  
* BFA-MFO-Lot-Ops-v1.0.md  
* HandOver-MFO-L1-L10-2026-09-20.md

## **1\. Đánh giá phản hồi hiệu chỉnh của Perplexity**

### **1.1. Nhận xét tổng quan**

* **Mức độ sẵn sàng (Readiness Level):** **Xuất sắc (Production-Ready Alignment)**.  
* Perplexity đã tiếp thu toàn bộ bản chất cốt lõi của hệ thống: loại bỏ hoàn toàn tư duy bảng tạm (temp\_data), xác nhận dữ liệu được tạo thật ngay sau khi nhận tem plan\_ok, và giới hạn đúng 4 khối chức năng trọng tâm của FE MFO.

### **1.2. Phân tích điểm Perplexity giữ lại: "API Integration Verification"**

* **Đánh giá:** **Perplexity giữ lại điểm này là HOÀN TOÀN CHÍNH XÁC.**  
* Trong kỹ thuật phần mềm, việc đối chiếu trực tiếp schema, command payload, response code và guard backend thực tế không phải là over-engineering mà là **bước kiểm định hợp đồng tích hợp (Integration Contract Verification)** tối thiểu bắt buộc phải làm trước khi viết component.  
* Việc kiểm tra này giúp FE không bị "ảo tưởng" về dữ liệu trả về và bắt đúng các mã lỗi nghiệp vụ của BE.

## **2\. Chuẩn hóa Hợp đồng Dữ liệu (Contracts) & Error Mapping cho FE**

Dựa trên code backend đã live (mfo.service.js, mfo.routes.js, BFA-MFO-Lot-Ops-v1.0), FE cần cố định các hợp đồng sau:

### **2.1. Payload Tạo Kế Hoạch (POST /api/mfo/plans)**

interface MfoPlanSubmitPayload {  
  origin\_member\_id: string; // UUID của Origin đã có trên sổ  
  k: number;                // Số bước huyết thống (0..4) từ Origin tới MWL  
  note?: string;            // Ghi chú trình duyệt  
  lines: \[MfoLine, MfoLine, MfoLine, MfoLine, MfoLine\]; // Đúng 5 phần tử (Line 0..4)  
}

interface MfoLine {  
  line: 0 | 1 | 2 | 3 | 4;  
  op: 'ASSIGN' | 'CREATE' | 'EMPTY';  
  member\_id?: string | null; // Bắt buộc nếu op \=== 'ASSIGN'  
  hint?: string;             // Mô tả gợi ý (vd: "Cha mẹ đời 1", "Founder")  
}

* **Guard BE:**  
  * Nếu ![][image1] MFO\_K\_OUT\_OF\_RANGE.  
  * Nếu ![][image2] mà Line ![][image3] có op \!== 'ASSIGN' ![][image4] MFO\_K\_MUST\_ASSIGN\_FOUNDER.  
  * Dòng 0 bắt buộc op: 'ASSIGN', member\_id: origin\_member\_id.

### **2.2. Payload Thao tác trong Workbench (Sau khi có plan\_ok)**

#### **A. Tạo Thành viên (POST /api/mfo/plans/:id/members)**

interface MfoMemberCreatePayload {  
  line: 1 | 2 | 3 | 4;          // Không tạo vào Line 0 (Origin)  
  full\_name: string;            // Trim client-side trước khi gửi  
  gender: 'NAM' | 'NU' | 'KHAC'; // Bắt buộc khi tạo  
  father\_id?: string | null;    // Ít nhất 1 trong 2 (father\_id | mother\_id)  
  mother\_id?: string | null;    // Nếu Line k bỏ trống \-\> BE tự clone từ Founder  
  birth\_year?: number | null;  
  child\_type?: 'CON\_DE' | 'CON\_NUOI' | 'CON\_DAU' | 'CON\_RE' | 'KHAC'; // Default: CON\_DE  
  sibling\_seq?: number;  
  note?: string;  
  link\_founder?: 'FATHER' | 'MOTHER'; // Tùy chọn: tạo xong gắn thẳng làm cha/mẹ MWL  
}

#### **B. Sửa Thành viên (PATCH /api/mfo/plans/:id/members/:memberId)**

* **Quy tắc A01:** FE **vô hiệu hóa hoàn toàn** hoặc không render input cho: gender, is\_alive, phone, email.  
* Chỉ cho phép sửa: full\_name, birth\_year, father\_id, mother\_id, child\_type, sibling\_seq, note.

#### **C. Gắn Đôi / Hôn nhân (POST /api/mfo/plans/:id/spouses)**

interface MfoSpouseAttachPayload {  
  member\_id: string;        // Người trong dòng họ  
  spouse\_id?: string;       // Nếu chọn spouse đã có trên sổ  
  spouse\_data?: {           // Nếu tạo mới người phối ngẫu  
    full\_name: string;  
    gender: 'NAM' | 'NU' | 'KHAC';  
    birth\_year?: number;  
  };  
  marriage\_status?: 'DANG\_KET\_HON' | 'DA\_LY\_HON' | 'DA\_MAT';  
}

### **2.3. Bảng Ánh Xạ Lỗi Kỹ Thuật ![][image5] Trải Nghiệm Elder Doctrine (Voice/UX)**

FE tuyệt đối không hiển thị mã thô (MFO\_\*) hoặc exception message ra giao diện. Message Orchestrator tại FE sẽ chuyển đổi theo bảng sau:

| Mã lỗi Backend | Nguyên nhân kỹ thuật | Thông điệp VoiceHelp / Elder UX hiển thị cho người dùng |
| :---- | :---- | :---- |
| 409 MFO\_MEMBER\_DUP | Trùng Họ tên \+ Giới tính \+ Cha/Mẹ \+ Năm sinh trên toàn tenant | *"Thưa bác, người này dường như đã có tên trong sổ họ (trùng họ tên, giới tính và cha mẹ). Bác vui lòng kiểm tra lại danh sách hoặc chọn từ sổ thay vì tạo mới."* |
| 422 MFO\_K\_MUST\_ASSIGN\_FOUNDER | Dòng ![][image3] không đặt lệnh ASSIGN Founder | *"Dòng số {k} là đời của bác (hoặc người chủ trì khai). Xin bác hãy chọn chính mình tại dòng này trước khi nộp kế hoạch."* |
| 422 MFO\_LINE\_EMPTY\_FORBIDDEN | Cố tình gọi POST /members vào đời đánh dấu EMPTY | *"Đời này đã được khóa theo kế hoạch đã duyệt. Bác không thể thêm người vào đời này trong lô hiện tại."* |
| 422 MFO\_K\_OUT\_OF\_RANGE | ![][image6] (Origin cách quá 4 bước huyết thống) | *"Cụ/ông được chọn làm gốc cách quá 4 đời so với bác. Xin bác hãy chọn một bậc tiền nhân gần hơn (ông nội hoặc cha) để lập kế hoạch 5 đời."* |
| 409 MFO\_LOT\_ALREADY\_OPEN | Đang có 1 lô chưa nghiệm thu giữa Founder và Origin này | *"Bác hiện đang có một lô phác thảo chưa hoàn tất nghiệm thu với gốc này. Bác hãy hoàn thành lô trước hoặc nhờ quản trị viên hỗ trợ."* |

## **3\. Kiến trúc State & Luồng Tương tác của 4 Khối FE**

\[1. Dashboard\] ──────────► \[2. Plan Wizard\]  
     ▲                             │ (Submit PLAN \-\> Chờ Admin cấp tem)  
     │                             ▼  
\[4. Admin Review Modal\] ◄── \[3. Workbench (Khi có plan\_ok)\]  
  (Cấp plan\_ok /              ├── Tree View 5L (Live SVG/Canvas/DOM)  
   Nghiệm thu RESULT)          ├── Member Drawer Form (POST /members)  
                               ├── Spouse Modal (POST /spouses)  
                               └── Nút "Nộp nghiệm thu" (POST /result)

1. **Khối 1: Dashboard (MfoDashboardPage)**  
   * Hiển thị danh sách Lô MFO với filter: mine=1 (Lô của tôi) hoặc toàn tenant (cho Admin).  
   * Badge trạng thái chuẩn: DRAFT, PENDING (chờ duyệt plan), UNDER\_REVIEW (đã có plan\_ok), NEEDS\_REVISION, APPROVED.  
2. **Khối 2: Plan Wizard (MfoPlanWizardModal)**  
   * **Bước 1:** Picker chọn Origin (lọc danh sách members sẵn có, tuyệt đối không tạo UM ở đây).  
   * **Bước 2:** Hệ thống tự động tính ![][image3]. Nếu ![][image6], khóa nút Tiếp tục và báo VoiceHelp.  
   * **Bước 3:** Hiển thị 5 dòng (L0 đến L4). Line 0 cố định ASSIGN Origin. Line ![][image3] cố định ASSIGN MWL. Các line còn lại cho user toggle CREATE hoặc EMPTY.  
   * **Bước 4:** Bấm Gửi kế hoạch ![][image5] gọi POST /api/mfo/plans.  
3. **Khối 3: Workbench (MfoWorkbenchView)**  
   * Kích hoạt khi ticket có tem plan\_ok.  
   * **Sử dụng Server State thuần túy:** Mỗi thao tác POST /members hay POST /spouses thành công lập tức trigger React Query / SWR gọi GET /api/mfo/plans/:id để kéo lại tree mới nhất từ backend. **Tuyệt đối không lưu dữ liệu người vào LocalStorage hay State cục bộ.**  
   * **Nối Founder:** Kiểm tra nếu Founder chưa có father\_id/mother\_id, hiển thị cảnh báo hướng dẫn người dùng tạo người ở Line ![][image7] và gắn làm cha/mẹ.  
4. **Khối 4: Admin Review (MfoAdminReviewDrawer)**  
   * **Duyệt Plan:** Admin nhập granted\_generation ![][image5] gọi POST /plans/:id/approve.  
   * **Nghiệm thu Result:** Xem đối chiếu cây thực tế với 5 dòng ban đầu ![][image5] gọi POST /plans/:id/result/approve.

[image1]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIwAAAAgCAYAAADAHpCrAAAEsElEQVR4Xu2aW4hNURjHhyH3XMcwl7NmnxmmiDBRyou8SIkXL8KDB5dBEvFCvFBe3FIklzwoSUkpSZFLEVEuKbkltyEhiXH3/2Z/izWftefstfc5M07Wr77OXv/vW9+67r3XOTMlJR6Px+PxeDwez/+EUuok7BHsJ+yD9BcLNTU1U4MgKJd6sYE1mC21f4nSTCazFZ38yhtmiwwoBiorKwdS/zGWudJXTGAMa2kcUtfgpjjC6/TboI2RcRrX+Ngg0StKVlFRMUj6igE9GUW+YbrocUgHAf0jbJ8uV1VVjTI2wjozlnCNd0InknoxgH4f0v0v5g2D/n+OWgeMazX0JqlDm2zUKdW6a7wrnaM66gI6maUc+NwkfYUCbfVHmz9gZ7jtdtkwaGsoHu1DpJ4U9HsNcp6OWgdoz9vwtejIccDQnOKdQOWVnGC39CUBE7mBO3VU+vINtVNWVtZbtfOGweN9GNq7JfWEtNywdBG1yBjXuSif1mHvtOYa7wRV5ARDtYYJ6YHyfdi3bDbb14yPC+o2Ul5soCsodpL+tCD3HjK+btcNQ1B7UksC8nzEfNfxNa2DNS/GthxnzJ5S13Uwz8dN3TU+NrKTNOkoP2bfCdirP9HuoGMzuY0n5eXlvaQ/CZTH7LPqmA2zDmM7KHUXUH8x8lzSZbkWMeik69A3Rem04Br/F63OL/hchUFs5mt9CHvaukoygiCYoMLzxgfcUZXS7wJyfKfzi1Fu9w1DoM3m6urq8VKPi553syy1tkDsDa5zXfpsuMb/BTbHCk6wH9fbMOGrDd928uGzn1knLZnwcNwM+4brEdKfC9TZBDtsaqqDNgyhwhtrldRzgTpvcBONFhqtRawNw+coio/1BnCNt4LKb3UnMdlzpL+Q0BMC7b6OO0FEQ0NDV1u8SrBhELsMdV7kyX6yjZXt2EDbs3Aj3pS6ziN1C6Uce0c6InCNt2MMdL++xkA2yLh8w2eQp9QeJm+69Eehwrt5It6/VfRngLq6ujIyaBe5/0uo7PBUpMN4KkP/J3Hb80tiQvFBECi8zipqa2sHG+NoWQNdphtE1iU47oTUo3CNj0KfX35oQfETJ+0ZIwos5BDkf09tYsImSH8u9ITGsAuybiHAeGagrWap58LSX6thM06x1P0C22Fq/K32ualpXOMjQYWl3LGdhraRNEzEQi6Pgx37UysZdFZR4d+rPiF3jfSnhcfh9EpKC54A3ahNqadBj0PqGvialOW8hCldnLH8juYa3yZI9Iw6R49ErSHJKdLoUckxd5P+DkPQHcKT8DJNnlzoiUZ786SvUKC9t2gvK/U06HFInYB+GXYB1oh2F2DRF+FzOWy9Cp8i09LE58TWOUpIGh5ZA/gOcn7cEsgzh/PfRrGL9OcLtNMAm67HArsKm4zNOVzG5hs5d0nBQnanr+bIN1+Pgxd1Yn19fR+KQXmXMUarlbT+W5JTfCy44lmLfo1936UvF4pfc+jwKekrBCr8lfqxCn+Vvgd7AHuGRTgvY/MJ3a1KnAuSgrkaqcL/FnjE4yB7CHuZ4TMMzWkuM3NKn83M+A6BDsroyF6pezwej8fj8Xg8Ho/H4/F4PB6PpwD8ArhNKkQ2HQUVAAAAAElFTkSuQmCC>

[image2]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAD0AAAAgCAYAAAChKnCsAAACcElEQVR4Xu2XS0iUURTH1cEem7QHgvP65tVmlg0EbtwKLqNV5rqNIKEotHLTQsRKcSEEs4ygICm1x0aCFm7apwYW2EJdqKik+PyfPNeuhxnsu/cOhN4fHOb7zv887pl7v2+0qsrj8XjOEkEQvIfNww5gG1I/i0SSyeRTDLvDQz+RASGoSaVS9dJZSbD2q1jzOuyN1E4FSUs0dDQavSG1EFSjxjJsD9YkRVeg9nPYb94kZUZD/0mWfhPy+fwF7Pgs17wndVuwu3dRtxWXEfQZMh26xuXQOqj5hepioT1Sc4Hx0Ejo4oWNSs0VqP+KetAipWaDzdCrnNiofPF4/DLuv8N2M5lMnR5vA+oNc6/XUjPBZmhKOj7a2PF23P9kbRy29DfaDaj5iHqi12ephcF06BPPMz67Uaifr7dZWziZ4g7Unla9TVBD48sbk1pZkPSQByvi+pn+wlEFUxX47UXdQe5rdcy1Nb6VWlmQsMLN6du6L3XXoM8L7jcsNRO04/1OamVRA8OK6hqF+mScLag7RbXxxfZKzQZt6AmplUM9z/vKEfDO4+0d0wNNKBQKtaj1jXu0Sd0F2tCTUisJAjs4YUTzPSYfij3g+1tByDdjLpe7gpxFqpNOp5ul7hI1NE7QB6mVBMG/KCGbzTYoH5I/ki+RSEQ5ZuZff6exgEuIX4Nt46TclHol0F5kn6RWEgom030YupN8WPQ17NhFXG/p+ilUU550uoYePZyg2xi0JeB/lGCbsDvB0clMy5xjOHiqhP8ra3tS+x/AugZ42B/B0V+Nc/xJ94vYuJcyx+OxJBaLXefHIrTJWh6Px+PxnGMOAU1F50bt+DeCAAAAAElFTkSuQmCC>

[image3]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAgCAYAAAAi7kmXAAABHklEQVR4XmNgGAXEAXl5+e1AfB+I/wPxF3R5XIBZTk6uH6jhN1RjH7oCvACo4RVIo5SUlAi6HF4Ate0/ujghwESWRqCGYpAmoF9noMvhBUBNH6A2SsLEZGRkOIH8O0D8R0lJiR9ZPRygOxNocyyQ/xAqtwWIXyFUIwCK/4B0iYKCQieU/RMq9wRVCxAAFRVCJecB2ROAtpUhyU0EyQFpAWQ9YACUeA+zEagpBl0eJ4BpAtkIYwNtaEBXhw5g/vsHE4C5ABiq0sgKUQBQQQ5U4xQksVaorelQvhEQr0foggg+BSlSVlYWg4kB/bkTJCYrKysFVXMTIx6htqEkM6DGfKhThVRUVNiB7B/I8mAA1bgfi/hZqNxfdLlRMArIAwApGWFIY7HkmAAAAABJRU5ErkJggg==>

[image4]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEcAAAAfCAYAAAC1bdCFAAACYElEQVR4Xu2XsUtbURTGo7RFSqWLAUnykry8R4PpUEn2VgsOcXHo3qFLpC6COLR/QQP+EYL4F3Qorg7ZuhQHoU0RDdggiItKg9h+R++D25ObZ07eHYTeH3wk+c737r3n5CUhqZTD4XA4HHFks9lcPp9f4L4DFAqFP1Cb+0SlUnmEWk9lIu3zXIQ0f6/Bwb+qBvqGk8lkHlMNj1ORhztsJ2oaLx9ocXH+XoODP48ObhqO8usG/0xrWPdFeatg8UXuJYEOWywWX6mDDxoOaV33fd9/YWpWmrcKFt+G3nB/FLBOC1rBwV+qgw8cDgbYjKnNGryh8lZJp9NPsMEV96XkcrkQ61zQ87jh0K8YmmlwX53jplndl+atgw269F3BfQnqkOP0PG44g8D+m5JmpflEqE3GuD8MuPYL3t0P0etRhhM1Cs3wmglpPhHlcnmSNkOTRV6LA/FpXNfTPelwkNujPO6Gt7xmQpTHAb8hfGxBJ4Xbps5TQ95FlK/Vag91TzIcZD6q7DyvmZDmCWoksbDhFtTzfb+cGgLK02c/CAKP7qAwDNMkPF9SDRxEHr+WQG6Ocp7nBbxmQpq3BjZtYfNd7seBa7pqCHeKX0u/QuSXSqWnug+vBe+Z7hHSvDWwwTuow/1RwZA/qaEYP1aoT1Cd/jPxmmmQ0rxVbG+AZppqOD95jaAaMqvQMtTA6/fQGrRhOos0bw0sXoc+c38UsE4Veg116NBKtH5Vy1xrNaPYmqK8VbD4L/0fbxKw1m/oCGpD36Ef+MI+xOOllulrjumUrcnrXP/kHQ6Hw+FwOBz/OX8Bw/ZEGBS2Zf0AAAAASUVORK5CYII=>

[image5]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABoAAAAfCAYAAAD5h919AAAAoklEQVR4Xu2RMQoCMRQFY6+daVIkpkrhSbT1Bl5NPIE3sPAAnkFQsbYRYZ00Fg+s/CnEDDwWJgtDdp3rdDr/Q0ppqa4JhLZspd4c7/2Y0FN9EwhdY4xz9U0gNvAYqTenlDKpsRno2RvOjrx0NtiNDezuPtyuyq9HYMMeOefiWkHgwJfZqzeFyJqd1JtT/4s6c4gs2E69OUQuIYSp+k6n88O8AIPMMCJp/cwiAAAAAElFTkSuQmCC>

[image6]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAD0AAAAgCAYAAAChKnCsAAACh0lEQVR4Xu2Wu0tcURDGfSJiwFfWTfZ19oWFZRYClpImTSB/QLQVjCCiWNso2PgAixDELmARsBEkjYJaJaSzkSQEiRaKoIgQxec3e+fq2WHXu/fe3WLl/GDYe+abOefM7pmzt6rKYDAYnhJKqVXYX9gt7EzqlUI8Hn+bSCSC0p+P2lgsNoNiL7noaRlQCYTD4XbaP2rplVpBkHBISaFQ6LnUKgH+wVwXnU2S/koA+/7ipeiaUhSNBZO88KTUygXWasWaN7A1V0UjeIQTPknNC7hQxvlL/Cq1UkPrBAKBZ16KPuFNvrR9kUikEePfsKtkMtmsxxcLcgdoXnwJ3zGslrpfMPdnMn52XTQVfH+0KRHjXdZWYIcP0e5B0e95jX/BYLBJ6l6gefQ9uy06p5/xOYpNTvHzBWt7uSnewH/oa2X13xlOUljqbsAc19TP2rj4olHgMBe2iOdZJI1p2hxp+GzRc/zCF9457ArPXVJ3gi5K2JLuc1U0Ao+5aEr4IPVywjfvEa0ttUJkMpn6fPFui84WDFu0n+n2lXGlhntyjzf6TuqFUFbLdeMNLEKvnOl0OkAG3xbv/yONHzuddj/f2A7Fv7zfnisENvMC85/SmtTjUneC91uMbcrcLBAGOWBe802QD5vr5/Er2PJDljeod5X1fv8fc8el7he7WMfjjaB9CkylUh22D0nfyBeNRkMcs+P1f5rAfG94Qwd+5nFCK7pPajnYgboPSUPkw/FuQ2804Plc14uFLkWefxvDOqmXCqyToTvBrgX2A9aDL7hTxmbhoPU8/p+sXUvNCcUtQydGauVAWW+Tu8p6e/wF+wPbRwdtyNiyQJcfFlyQfoPBYDAYDAZDHu4AP3TqGPColC0AAAAASUVORK5CYII=>

[image7]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADoAAAAgCAYAAABD9mvVAAABtklEQVR4Xu2Xu0oDURCGo4JipYgIrptsLluljGDji1hobSOIKNY2FjZeUNAqr2AjiJVP4AMEbwQjQhpFBBWv/5A5yckQye4p3KOcD3727Mz8YWbP7iZJpRwOh8M2giA4hq6hL+hJ5v8LfZlMZgsDvvGgm7LARtDzPvUr412BqU5Gz/NGZc4GisViP/q75M1oStZ1xdj4e9CdN+v7fkgnpv32mhqTwqhfGJbJhCt2IHO2YjroAxvHVQy3yCDOL6D3fD4/pNfbgOmgbSbs7BzOq5w7guqtajuQPUeh7fnEcSWbzW7w+pVztXZL8sQeFEMtsamM9TZ2c1XL7VAOx2HdYwOxB0XxvTLR61vmo4KLMYPPuDNQRX5WFKhfkoz/iDJAZbVG02uyLiI9hopN3EHV8/mpAgHvMN66E3qhbcQaFIULbNjTYusUw67O83kJOmy57CDuoLdUXCgUxlQMz+kJxdLptMc1lT//PdqpGIMuUgy37kgYhgNYv+j5JEFvk9A0etpVvdO3RC6Xm8K6JOubcPFph/gZ5z5kLknQzyN0EzT+xZwHjV9uV1ANepb1DofD4XA4HA6dby3Qr9C4aIBhAAAAAElFTkSuQmCC>