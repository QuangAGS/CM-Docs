LEVEL D: PLATFORM MAPPING SPECIFICATIONS
[LEVEL D2] FRONTEND PLATFORM MAPPING SPECIFICATION (OFFICIAL FROZEN BASELINE V2.0)
Trạng thái: Frozen Baseline Approved | Phiên bản: V2.0 (Canonical Client Engineering Constitution)
Hệ thống: Nền tảng Quản lý Dòng họ Số (Clan Management Platform)
Cấu trúc thực thi: Absolute Production-Grade Client Engineering Contract (Zero Ambiguity)
1. PURPOSE & SCOPE (MỤC ĐÍCH & PHẠM VI)
Tài liệu này là Hiến pháp kỹ thuật mặt tiền (Frontend Engineering Constitution) tối cao dành cho Kỹ sư phát triển giao diện và các Trí tuệ nhân tạo lập trình (AI Coding Agents) của dự án Clan Management Platform. Tài liệu lấp đầy hoàn chỉnh 12 khoảng trống hệ thống từ phiên bản trước, đóng vai trò là một bộ Hợp đồng triển khai vật lý (Platform-Specific Model - PSM) khóa chặt cấu trúc, hành vi, ranh giới dữ liệu, và triết lý giao tiếp bất đồng bộ, bảo đảm AI và con người đồng nhất 100% trong quá trình sinh mã nguồn (Code Generation).
2. TECHNOLOGY DECISIONS & MATRIX
Hệ thống Client đầu cuối đóng băng cứng phân tầng giải pháp vật lý theo các tham số kỹ thuật doanh nghiệp:
Cross-Platform Mobile Core: React Native (v0.74+ New Architecture / TurboModules) phối hợp chặt chẽ cùng TypeScript (v5+ strict mode).
Web Operations Extension: React / Next.js (v14+ App Router) phục vụ riêng giao diện máy tính dành cho Ban quản trị tộc sự.
State Management & Sync Engine: TanStack Query (React Query v5) quản lý bộ nhớ đệm, tối ưu hóa payload, phối hợp Axios Interceptor truyền nhận gói tin.
Local Storage Core: SQLite thông qua thư viện `@op-engineering/op-sqlite` thực thi mã hóa native tốc độ cao làm kho lưu dữ liệu ngoại tuyến.
Form Engine & Schema Validation: React Hook Form phối hợp với Zod Schema Validation nhằm khóa chặt tính toàn vẹn của dữ liệu nhập liệu biên.
3. TARGET STACK OVERVIEW (TỔNG QUAN TẦNG CÔNG NGHỆ VẬT LÝ)
React Native Architecture + TanStack Query + OP-SQLite + React Hook Form + Zod + OpenTelemetry Context Propagation
4. FRONTEND ENGINEERING DOCTRINES (LINH HỒN KỸ THUẬT CLIENT)
Mọi luồng kết xuất dữ liệu và tương tác người dùng bắt buộc tuân thủ nghiêm ngặt chuỗi Pipeline 10 bước bất biến:
User Action Trigger → Pure UX FSM State Check → Accessibility Style Modifier → Local Cache Interception (TanStack Query) → Offline Queue Check → Network Guard (<100KB Payload Enforcement) → API Gateway Shipping → ID Identity Propagation → Optimistic UI View Update → Background Sync Reconciliation
5. ARCHITECTURE MAPPING (PIM TO PSM)
Cơ chế Level C (PIM)
Giải pháp Hiện thực Level D2 (PSM)
Giao ước Kỹ thuật (Engineering Contract)
 
Pure UX FSM
Custom React Hooks (useElderUXStateMachine)
Cô lập trạng thái tương tác lão thành (Idle, Recording, Screen Drafting, Interrupt Paused) khỏi logic nghiệp vụ.
Offline Sync (Vector Clocks)
TanStack Mutation Cache + OP-SQLite Meta Store
Cấm chiến lược LWW. Mọi lệnh Mutation khi offline được đẩy vào Offline Queue đính kèm Vector Clock cục bộ chờ đối soát xung đột đa hướng.
Mobile-First Boundary
GraphQL/Axios Response Interceptor
Tự động ngắt luồng xử lý và ném lỗi Canonical CLIENT_PAYLOAD_EXCEEDED nếu response từ Gateway vượt quá 100 KB.
Adaptive UX Styles
Dynamic Theme Context Matrix (ACXD Context)
Tự động đọc AccessibilityProfile từ bộ đệm để ép cỡ font chữ (Large/Extra Large) và kích hoạt High Contrast tương phản cao mà không cần reload app.
6. FEATURE MAPPING MATRIX (MA TRẬN PHÂN RÃ TÍNH NĂNG)
Để định hướng chính xác cấu trúc cho AI sinh mã trong thư mục features/, ma trận phân rã tính năng được chuẩn hóa cứng như sau:
Domain Domain
Feature Folder
Target Screens
Target Hooks
Offline Queue
 
Family (Tộc sự)
features/family/
TreeGraphView, BranchList, ProfileEdit
useFamilyTreeQuery, useBranchMutation
YES (Vector Clock)
Member (Thành viên)
features/member/
MemberList, MemberDetail, IdentityVerify
useMemberQuery, useVerifyMutation
YES (Merge Strategy)
Ledger (Sổ cái)
features/ledger/
LedgerOverview, AssetEntry, AuditLog
useLedgerQuery, useAssetMutation
NO (Online Only Required)
Communication
features/communication/
InboxChat, AnnouncementFeed, VoiceBroadcast
useChatSession, useVoiceBroadcast
YES (CRDT Append-Only)
7. UI COMPOSITION DOCTRINE & NAVIGATION STRUCTURE
7.1 Cấu trúc phân lớp cây UI (UI Composition Architecture)
Nghiêm cấm kỹ sư hoặc AI viết mã nguồn trộn lẫn các phân lớp hiển thị. UI bắt buộc phải được compose theo thứ tự phân rã nghiêm ngặt:
Screen (Quản lý Route & Container) → Section (Khối layout chức năng) → Card (Cụm thông tin thực thể) → Widget (Khối tương tác nhỏ) → Primitive (Atomic Elements - Button, Typography)
7.2 Navigation & Form Rules
Navigation Doctrine: Phân hệ di chuyển phân định rõ rạch ròi: Dùng TabNavigation cho 4 phân hệ lõi ở màn hình chính, dùng StackNavigation cho luồng xem chi tiết, và dùng ModalNavigation kết hợp FSM Hook riêng cho luồng nhập liệu phức tạp (Wizard/Form Session).
Form Engine Regulation: Toàn bộ các form nhập liệu bắt buộc sử dụng cặp bài trùng React Hook Form + Zod Schema. Nghiêm cấm sử dụng các thư viện quản lý state thủ công hoặc Formik.
8. REFERENCE PROJECT LAYOUT (SƠ ĐỒ THƯ MỤC CHUẨN)
src/├── App.tsx├── shared/                               # PHÂN HỆ TIÊU CHUẨN TOÀN CỤC (KERNEL CLIENT)│   ├── theme/                            # Khai báo Design Tokens Matrix (Spacing, Radius, Elevation, Colors)│   ├── hooks/                            # Custom React Hooks dùng chung (useNetwork, useFSM)│   ├── network/                          # Cấu hình API Client, Key Generation, Interceptors & Error Envelope│   └── database/                         # Trình khởi tạo và quản lý phân vùng OP-SQLite Local Store└── features/    └── [feature_name]/                   # Phân rã theo cấu trúc tính năng nghiệp vụ (Bounded Context)        ├── api/                          # TanStack Query Keys, Fetchers, Mutations & Zod Schema        ├── components/                   # Hệ thống UI Components (Tuân thủ UI Composition)        ├── hooks/                        # Feature-specific hooks (useElderWizardSession)        ├── screens/                      # Giao diện màn hình (Mobile View/Web Route)        └── offline/                      # Synchronization State Machine & Conflict Resolver
9. IMPLEMENTATION CONTRACTS (HỢP ĐỒNG TRIỂN KHAI)
9.1 Đồng bộ mạng với D1 (Backend Contract Mapping)
Mọi API Fetcher trong hệ thống bắt buộc phải giải nén và xử lý cấu trúc phong bì dữ liệu (Error Envelope) đồng bộ từ D1:
export interface CanonicalErrorEnvelope {  errorCode: string;         // Ví dụ: DOCTRINE_BREACH, INVARIANT_BROKEN  message: string;  correlationId: string;     // Khớp tuyệt đối với Trace ID từ OpenTelemetry Backend  timestamp: string;}
9.2 Elder Error UX Doctrine
Nghiêm cấm tuyệt đối sử dụng các hộp thoại cảnh báo Popup (Alert Dialog) gây nhiễu loạn thị giác người già. Lỗi phải được trình diễn inline trực quan, cỡ chữ tối thiểu 20pt, có nền cảnh báo tương phản cao, đính kèm nút "Thử lại một chạm" (One-Touch Retry Button) có kích thước vật lý tối thiểu 48dp x 48dp, đồng thời kích hoạt cảnh báo giọng nói (Voice Reader Adapter) nếu cấu hình Trợ năng đang mở.
10. OFFLINE SYNCHRONIZATION STATE MACHINE (MÁY TRẠNG THÁI ĐỒNG BỘ NGOẠI TUYẾN)
Trạng thái đồng bộ hóa của mọi lệnh Mutation khi mất mạng bắt buộc phải đi qua các bước chuyển đổi nghiêm ngặt được quản lý bởi OP-SQLite Meta Store:
[LOCAL_ONLY] → (Mất mạng) → [QUEUED] → (Có mạng lại) → [UPLOADING] → [WAIT_SERVER_ACK] → (Đối soát Vector Clock / Conflict Check) → [MERGED] → [DONE]
11. DESIGN TOKEN CONTRACTS (BẢN GIAO ƯỚC ĐỒ HỌA MÃ MÁY)
Nghiêm cấm kỹ sư và AI hardcode các tham số giao diện thô (e.g., `borderRadius: 12`). Toàn bộ hệ thống đồ họa phải gọi trực tiếp từ Design Tokens Matrix sau:
Token Category
Standard Mode Profile
ELDER_ACXD Mode Profile (Chế độ người già)
 
Layout Spacing
space_sm: 8px | space_md: 16px
space_sm: 16px | space_md: 24px (Giãn cách rộng)
Border Radius
radius_card: 8px | radius_button: 6px
radius_card: 16px | radius_button: 24px (Nút bo tròn mạnh)
Elevation / Shadow
shadow_low: 2dp | shadow_high: 6dp
shadow_low: 0dp | shadow_high: 0dp (Bỏ đổ bóng, dùng viền Stroke tương phản)
Contrast Ratios
Standard RGB Matrix (WCAG AA compliant)
Pure Black & Pure White / Stark Yellow (Contrast Ratio ≥ 7:1)
12. TESTING & QUALITY BUDGET GATES
Accessibility Compliance Testing (ACXD Testing): Bộ quét tự động CI/CD quét cây phân rã đồ họa Component, đảm bảo 100% các nút nhấn đều vượt qua tiêu chuẩn tương phản (Contrast Ratio ≥ 7:1) và có cấu hình hỗ trợ Screen Reader.
Performance Budgets (Hạn ngạch hiệu năng biên): Hệ thống Client áp đặt các hạn ngạch cứng kiểm tra tự động qua Profile Automation Tools:
First Paint (Thời gian lên màn hình đầu): < 1.5s trên thiết bị phân khúc thấp.
Navigation Transition (Độ trễ chuyển màn): < 250ms.
Screen Memory Cap (Giới hạn RAM tối đa cho một màn hình): < 80MB (Nghiêm cấm rò rỉ bộ nhớ).
13. AI CODING & COMPONENT GENERATION CONSTRAINTS (MỆNH LỆNH CHO TRÍ TUỆ NHÂN TẠO)
Mọi Trí tuệ nhân tạo đảm nhận nhiệm vụ thiết kế, sinh cấu trúc thư mục hoặc sinh mã nguồn cho tầng Frontend BẮT BUỘC phải tuân thủ tuyệt đối các mệnh lệnh cấu trúc sau:

1. AI SHALL NOT use relative deep imports exceeding 2 levels (e.g., ../../../../ is strictly prohibited); AI MUST use configured path aliases (e.g., @shared/, @features/).
2. AI SHALL NOT duplicate custom React Hooks or create standalone copies of GraphQL fragments; all shared network mutations MUST be declared inside the component feature api layer.
3. AI SHALL enforce strict feature isolation; files located inside features/member/ SHALL NOT import raw components directly from features/ledger/ without routing through the global shared interface layer.
4. AI SHALL automatically generate component code bundled together with its corresponding Testing specification file (.test.tsx), Storybook specification (.stories.tsx), Localization keys, and automated Accessibility labels.

14. CROSS REFERENCES (THAM CHIẾO CHÉO KIẾN TRÚC)
Tham chiếu hợp đồng băm mã hóa và Outbox tại [LEVEL D1] Backend Platform Mapping Spec V2.0 mục 6.1.
Tham chiếu mô hình lưu trữ và quy định cấu trúc thực thể tại [VOL III - 11] Enterprise Data & Persistence Architecture Spec V3.1.
[KẾT THÚC TÀI LIỆU LEVEL D2: FRONTEND PLATFORM MAPPING SPECIFICATION - FROZEN BASELINE VERSION V2.0 - CANONICAL APPROVED]