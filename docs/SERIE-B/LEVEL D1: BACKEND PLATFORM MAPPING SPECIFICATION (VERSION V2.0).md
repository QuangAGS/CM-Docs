LEVEL D: PLATFORM MAPPING SPECIFICATIONS
[LEVEL D1] BACKEND PLATFORM MAPPING SPECIFICATION (OFFICIAL FROZEN BASELINE V2.0)
Trạng thái: Frozen Baseline Approved | Phiên bản: V2.0 (Engineering Constitution)
Hệ thống: Nền tảng Quản lý Dòng họ Số (Clan Management Platform)
Cấu trúc thực thi: Absolute Production-Grade Architecture-to-Technology Mapping Contract
1. PURPOSE & SCOPE (MỤC ĐÍCH & PHẠM VI)
Tài liệu này là Hiến pháp kỹ thuật tối cao (Engineering Constitution) của đội ngũ kỹ sư Backend và các Trí tuệ nhân tạo đảm nhận vai trò sinh mã (AI Coding Agents) cho dự án Clan Management Platform. Đoạn tuyệt hoàn toàn với các ví dụ nghiệp vụ đơn lẻ mang tính minh họa, tài liệu này thiết lập các giao ước hạ tầng vật lý bất biến, các bộ lọc quy chuẩn tự động, và các ranh giới kiểm thử nghiêm ngặt nhằm ánh xạ trọn vẹn mô hình độc lập nền tảng Level C sang Node.js/NestJS Stack mà không làm suy hao hay biến dạng kiến trúc lõi.
2. TECHNOLOGY DECISIONS & PROFILE MATRIX
Hệ thống Backend đóng băng cứng phân tầng giải pháp vật lý theo các tham số kỹ thuật doanh nghiệp:
Runtime Environment: Node.js (v20+ LTS) phối hợp chặt chẽ cùng TypeScript (v5+ strict mode).
Framework Backend: NestJS Core (v10+) thực thi Module Isolation và Dependency Injection.
Data Access Layer: Prisma ORM (v5+) phụ trách quản lý phiên kết nối và tương tác PostgreSQL.
Event Transport Layer: BullMQ (v5+) vận hành trên hạ tầng phân phối Redis mã hóa dữ liệu.
Observability Tier: OpenTelemetry Node SDK thu thập Trace ID, Span ID tập trung.
3. BACKEND ENGINEERING DOCTRINES (LINH HỒN KỸ THUẬT BACKEND)
Mọi yêu cầu nghiệp vụ làm thay đổi trạng thái (Business Write Request) bắt buộc phải tuân thủ nghiêm ngặt chuỗi thực thi tuyến tính 13 bước bất biến sau. Nghiêm cấm mọi hành vi đi tắt đón đầu, bỏ qua phân tầng:
Controller → DTO Validation → Execution Context Inflation → Command Bus → Policy Pipeline → Application Service → Domain Core → Repository Adapter → Business Ledger Record → Outbox Queue Insertion → Database Commit → Projection Reindexing → Telemetry Shipping
4. ARCHITECTURE MAPPING (MAPPING LAYER CONTRACT)
Cơ chế Level C (PIM)
Giải pháp Hiện thực Level D1 (PSM)
Giao ước Kỹ thuật (Engineering Contract)
 
CQRS Engine
@nestjs/cqrs Bus Core
Tách biệt hoàn toàn tệp tin mã nguồn. Command Bus tuyệt đối không trả về Data Entity, chỉ trả về Execution Ack/Saga Tracking ID.
Domain Policy Engine
NestJS mTLS Interceptors / Guards Pipeline
Ép buộc nạp ExecutionContext. Trình tự thẩm định: Doctrine Rules → Configurable Rules → Governance Policies → Domain Invariants.
Saga Coordinator
Metadata State Machine + BullMQ Queue/Workers
Saga là một máy trạng thái mô tả bằng Metadata JSON. BullMQ đóng vai trò Transport truyền mẩu tin kích hoạt Worker xử lý phân đoạn.
Ledger Recorder
Crypto Engine + Application Unit of Work (UOW)
Cách ly độc lập khỏi Prisma Hook. Nằm trong Application Service, băm chuỗi tuần tự Canonical trước khi chuyển xuống Repository.
Projection Builder
BullMQ Event Router + Versioned Schema Reindexing
Lắng nghe Outbox, phân tách phiên bản Read Model, thực thi định tuyến thông qua cấu trúc mạng lưới phân tán bất đồng bộ.
5. REFERENCE PROJECT SKELETON (KHUNG DỰ ÁN VẬT LÝ)
src/├── app.module.ts├── shared/                               # HẠ TẦNG CHUNG TOÀN CỤC (KERNEL PACKAGES)│   ├── execution-context/                # Định nghĩa Interface cấu trúc ExecutionContext toàn vẹn│   ├── exceptions/                       # Bộ quản lý Global Canonical Errors & Filters│   ├── telemetry/                        # Cấu hình OpenTelemetry Tracing & Span Injectors│   ├── security/                         # Mã hóa, Decryption và bộ lọc Sanitization biên│   └── policy/                           # Nhân thực thi bộ lọc Policy Pipeline└── modules/    └── [domain_name]/                    # Phân rã theo ranh giới miền nghiệp vụ (Bounded Context)        ├── [domain_name].module.ts        ├── domain/                       # Nhân Nghiệp Vụ Thuần Túy (Pure Domain - Không dính líu Framework)        │   ├── entities/                 # Lớp thực thể logic định danh        │   └── value-objects/            # Đối tượng giá trị bất biến (Money VO, Precision, Scale)        ├── application/                  # Lớp Ứng Dụng (Use Cases & Orchestration)        │   ├── commands/                 # Cấu trúc Command & Command Handlers        │   ├── queries/                  # Cấu trúc Query & Query Handlers        │   └── sagas/                    # Khai báo Metadata Saga Workflow Definitions        └── infrastructure/               # Lớp Thích Ứng Vật Lý (Adapters Layer)            ├── persistence/              # Hiện thực Repository thông qua Prisma Client            ├── queue/                    # Cấu hình BullMQ Workers & Outbox Relayer            └── presentation/             # REST / GraphQL Controllers tiếp nhận đầu cuối
6. IMPLEMENTATION CONTRACTS (GIAO ƯỚC TRIỂN KHAI CHO HANDLERS)
Mọi bộ xử lý lệnh (Every CommandHandler) bắt buộc phải hiện thực hóa chuẩn xác cấu trúc luận lý sau dưới dạng một bộ khung mẫu không được gãy đổ:
@CommandHandler(EveryTargetCommand)export class GenericCommandHandler implements ICommandHandler<EveryTargetCommand> {  constructor(    private readonly policyEngine: DomainPolicyEngine,    private readonly appService: ApplicationUseCaseService,    private readonly unitOfWork: PrismaUnitOfWork  ) {}  async execute(command: EveryTargetCommand): Promise<ExecutionResult> {    // 1. Thực thi Domain Policy Pipeline thẩm định Hiến pháp tộc sự    await this.policyEngine.evaluatePipeline(command.ctx, command.payload);    // 2. Kích hoạt Unit of Work đảm bảo ranh giới Database Transaction nguyên tử    return await this.unitOfWork.runInTransaction(async (tx) => {      // 3. Thực thi UseCase xử lý logic nghiệp vụ miền      const domainResult = await this.appService.execute(tx, command.payload);      // 4. Record Business Ledger tuần tự hóa mã băm liên xích (Canonical Serialization)      const ledgerBlock = await this.unitOfWork.ledgerRecorder.hashAndAppend(tx, domainResult);      // 5. Viết mẩu tin sự kiện nghiệp vụ vào bảng Outbox cục bộ      await this.unitOfWork.outboxRelayer.enqueue(tx, ledgerBlock.eventLog);      return { success: true, trackingId: command.ctx.correlation.correlationId };    });  }}
7. CODING STANDARDS & DOMAIN VALUE OBJECTS
Money Value Object Standard: Nghiêm cấm tuyệt đối kỹ sư viết lệnh gọi trực tiếp decimal.js bừa bãi trong mã nguồn. Toàn bộ các giá trị tài chính bắt buộc phải được bọc trong một Class Money Value Object bất biến, định nghĩa rõ ràng các thuộc tính amount: String, currency: String, precision: 4, và scale: 2, thực thi đóng gói sẵn các hàm toán học an toàn.
Connection Limit Dynamic Policy: Loại bỏ toàn bộ các tham số số học cấu hình cứng. Biến số giới hạn bể kết nối (Connection Pool Size) của Prisma lên PostgreSQL bắt buộc phải được tính toán động dựa trên hồ sơ triển khai môi trường vật lý (Deployment Profile): connection_limit = min(CPU * 2 + Spindle, RAM_Cap, PG_Max_Connections).
8. SECURITY STANDARDS (BỐN PHÂN LỚP PHÒNG VỆ BIÊN)
Hệ thống xử lý chuỗi văn bản và an ninh đầu vào bắt buộc tách rời thành 4 trách nhiệm kỹ thuật biệt lập cấu hình qua các lớp NestJS Pipes tập trung:
Validation Tier: Sử dụng class-validator để đối chiếu kiểu dữ liệu cấu trúc đầu vào của DTO.
Canonicalization Tier: Đồng bộ hóa định dạng biểu diễn dữ liệu (chuẩn hóa Unicode NFC, cắt khoảng trắng thừa).
Sanitization Tier: Chạy bộ lọc thô bóc tách và vô hiệu hóa các mã độc ký tự lạ nguy hiểm nhằm triệt tiêu nguy cơ tấn công SQL Injection và Prompt Injection.
Output Encoding Tier: Mã hóa toàn bộ dữ liệu đầu ra trước khi kết xuất trả về client Web/Mobile để chống XSS.
9. TESTING & QUALITY GATES CONTRACTS
Để ngăn chặn hành vi AI sinh mã nguồn thiếu kiểm thử hoặc kiểm thử sai quy cách, dự án thiết lập 6 ranh giới kiểm thử bắt buộc (Quality Gates) kiểm tra tự động qua CI/CD Pipeline:
Unit Tests: Cô lập hoàn toàn Framework, kiểm thử 100% các nhánh logic của lớp Pure Domain Core (Entities / Value Objects).
Integration Tests: Kiểm thử khả năng kết nối giữa Repository và Docker Testcontainers PostgreSQL/Prisma Client thực tế.
Contract Tests: Sử dụng mẫu Consumer-Driven Contract Testing bảo đảm tính khớp dữ liệu payload giữa API biên và Mobile client.
Saga Machine Tests: Mô phỏng hành vi sập nguồn giữa chừng để kiểm tra độ tin cậy của lệnh bù đắp dữ liệu (Compensations).
Ledger Integrity Tests: Chạy lệnh giả lập thao túng một dòng bản ghi trong DB để xác thực xem hệ thống cảnh báo gãy chuỗi băm Ledger có kích hoạt ngắt mạch tự động hay không.
10. AI CODING CONSTRAINTS (RÀNG BUỘC CHO TRÍ TUỆ NHÂN TẠO SINH MÃ)
Mọi Trí tuệ nhân tạo đảm nhận nhiệm vụ lập trình (AI Coding Agent) khi tiếp cận và sinh mã cho hệ thống Backend này BẮT BUỘC phải tuân thủ tuyệt đối 5 mệnh lệnh ràng buộc cứng (Enforcement Mandates) sau:

1. AI SHALL NOT bypass the CommandBus under any circumstances for state-changing requests.
2. AI SHALL NOT bypass the Repository Adapter to write direct, raw SQL queries via Prisma Client.
3. AI SHALL NOT access or modify the business_ledger storage without invoking the Ledger Recorder Mechanism.
4. AI SHALL NOT skip the Domain Policy Pipeline or bypass mTLS Guard checks in the presentation controllers.
5. AI SHALL structured every new package inside the strict Hexagonal layout template defined in Section 5.

11. CROSS REFERENCES (THAM CHIẾO CHÉO KIẾN TRÚC)
Tham chiếu hợp đồng máy trạng thái Pure UX FSM tại [LEVEL C] Architecture Realization Mechanisms Spec V3.0 phân mục 6.5.
Tham chiếu học thuyết an ninh an toàn dữ liệu số tộc tại [VOL II - 05] LAAC & Security Architecture Spec V3.2.
[KẾT THÚC TÀI LIỆU LEVEL D1: BACKEND PLATFORM MAPPING SPECIFICATION - FROZEN BASELINE VERSION V2.0 - CANONICAL DESIGN APPROVED]