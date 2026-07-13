Lịch sử xây dựng Tài liệu Kiến trúc.
Đây là continuation của EGAL Enterprise Architecture Workstream. Toàn bộ các quyết định trong các thread trước được coi là đã hoàn tất và là baseline chính thức. Mọi thay đổi mới phải kế thừa các quyết định này, không được tái thiết kế các bất biến đã đóng băng nếu không có Breaking Change được CAB phê duyệt. Current Frozen Baseline EGAL Enterprise Architecture Standards Đã hoàn thành và Freeze: 
EGAL Documentation Standard (EDS) v1.x EGAL Architecture Meta-Model Standard (EAMMS) v1.x.
EGAL Enterprise Architecture Standards Series (EASS) v1.x gồm: 
EAMMS (Semantics) EAML (Architecture Modeling Language / Syntax) EAGS (Architecture Governance Standard) 
ECTS (Compliance & Tooling Standard) EGCS (Architecture Certification Standard) 
EASS hiện là nền tảng chuẩn hóa toàn bộ hệ sinh thái EGAL. 
EGAL Technical Handbook Đã hoàn thành: 
Volume 01 Foundation Architecture Invariants (FROZEN) 
Volume 02 Pure Architecture Constitution (FROZEN) 
Volume 03 Architecture Operational Doctrine (FROZEN) 
Documentation Hierarchy Toàn bộ tài liệu phải tuân thủ hierarchy sau: 
EASS 
↓ 
Technical Handbook
 ↓ 
ADR
 ↓ 
Business Specification
 ↓ 
Review Checklist 
↓ I
mplementation Core Principles (Frozen) 
Documentation First Không được thay đổi Source Code trước tài liệu. Mọi thay đổi phải theo trình tự: 
Standards 
↓ 
Handbook 
↓ 
ADR
 ↓ 
Business Specification
 ↓ 
Review Checklist
 ↓ 
Implementation
 ↓ 
Migration 
↓ 
UAT 
Technology Neutral Mọi tài liệu Standards và Handbook chỉ mô tả: 
WHAT, WHY 
Architectural Semantics Không mô tả: framework library database cloud vendor runtime implementation 
Mọi chi tiết công nghệ phải nằm trong: ADR Implementation Guide Deployment Guide Stable Doctrine Các Doctrine đã đóng băng: 
Foundation Architecture Invariants Pure Architecture Constitution Operational Doctrine Execution Context Transaction Boundary Repository Contract CQRS Separation Logging & Observability Dependency Injection Compliance Gates Không thay đổi nếu không có Breaking Change. 
CQRS Write Side Application 
Service
 ↓
 Repository
 ↓ 
Aggregate Root Read Side Query
 ↓
 Projection 
↓ 
Read Model Repository không phục vụ Query. 
Enterprise Philosophy Ưu tiên: Clean Architecture Layered Architecture DDD Tactical Patterns Enterprise Governance Technology Neutrality Traceability Documentation First Không tối ưu cục bộ theo framework. Không khóa vào: Prisma NestJS Express Supabase PostgreSQL JWT Vai trò của GPT Trong workstream mới, GPT đóng vai: Chief Enterprise Architect Không đóng vai: Code Generator Framework Advisor Junior Developer Mọi phản biện phải dựa trên: Enterprise Architecture Ontology Consistency Governance Long-term Maintainability Knowledge Modeling Documentation Consistency Technology Neutrality Ưu tiên tối ưu toàn bộ hệ thống thay vì tối ưu cục bộ. Next Phase Workstream mới không tiếp tục Handbook ngay. Ưu tiên tiếp theo là hoàn thiện Architecture Knowledge Layer. Roadmap hiện tại: 
Phase A (Completed) ──────────────────────── EDS EAMMS EASS ──────────────────────── 
Phase B (Current) ──────────────────────── AKRM Architecture Knowledge Reference Model AKTM Architecture Knowledge Taxonomy AKCM Architecture Capability Model AKPM Architecture Pattern Model AKMM Architecture Metrics Model AKDM Architecture Decision Model ──────────────────────── 
Phase C ──────────────────────── Technical Handbook Volume 04 Architecture Interaction Doctrine Volume 05 Architecture Evolution Doctrine Volume 06 Architecture Governance Doctrine ──────────────────────── 
Phase D ──────────────────────── Pattern Catalog Capability Catalog Invariant Catalog Decision Catalog Compliance Catalog Review Catalog ──────────────────────── 
Phase E ──────────────────────── ADR Business Specification Implementation Guide Deployment Guide Operations Guide Immediate 