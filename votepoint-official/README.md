# VotePoint Official — hệ thống bình chọn 4 cổng

Đây là bộ mã nguồn full-stack triển khai được với PostgreSQL dùng chung; vẫn cần cấu hình tài khoản hosting, kiểm thử end-to-end và rà soát bảo mật trước sự kiện chính thức.

## Tính năng trong bộ mã
- 4 cổng: Khán giả (`/vote`), Ban giám khảo (`/jury`), Tiền bối (`/seniors`), Ban tổ chức (`/admin`).
- Khán giả phân bổ chính xác **150 điểm**, mỗi mã ngẫu nhiên chỉ bỏ phiếu một lần; database chỉ lưu hash mã.
- BGK và tiền bối chấm 0–100 cho từng ứng viên; nộp là khóa phiếu.
- Trọng số Giải Tinh Hoa Nghệ Thuật: khán giả 30%, tiền bối 30%, BGK 40%.
- Giải Dấu Ấn Khán Giả theo riêng điểm khán giả; Giải Dấu Ấn Thế Hệ theo riêng điểm tiền bối.
- Tài khoản theo vai trò, mật khẩu băm, phiên đăng nhập lưu trong PostgreSQL, rate limit, audit log, xuất CSV.
- Ban tổ chức mở/đóng cổng bình chọn và cổng chấm điểm, sửa tên ứng viên, tạo mã khán giả và tài khoản chấm.

## Triển khai đề xuất
1. Tạo một repository riêng trong GitHub và upload toàn bộ thư mục này.
2. Tạo dịch vụ Node web + PostgreSQL trên Render (có thể dùng `render.yaml` làm mẫu).
3. Đặt `DATABASE_URL`, `SESSION_SECRET`, `NODE_ENV=production`, `BOOTSTRAP_ADMIN_USER`, `BOOTSTRAP_ADMIN_PASSWORD` và tùy chọn `CANDIDATE_COUNT` (11–30, mặc định 15) trong phần Environment/Secrets của dịch vụ. Mật khẩu quản trị nên dài, duy nhất và không chia sẻ.
4. Deploy. Khi server khởi động, nó tạo schema và tài khoản quản trị đầu tiên nếu hai biến `BOOTSTRAP_ADMIN_*` được cấu hình. Sau khi tạo admin đầu tiên, xóa hai biến bootstrap và redeploy.
5. Đăng nhập `/admin`, cập nhật tên ứng viên, tạo tài khoản BGK/tiền bối, tạo mã khán giả, sau đó mới mở cổng.
6. Khi có URL HTTPS thực tế, tạo 4 QR dẫn tới `/vote`, `/login?next=/jury`, `/login?next=/seniors`, `/login?next=/admin`.

## Lưu ý vận hành
- Đây là mã nguồn triển khai được, nhưng chưa tự xuất bản lên Internet vì cần quyền truy cập tài khoản hosting/database do chủ sự kiện kiểm soát.
- Trước sự kiện chính thức, cần kiểm thử end-to-end và rà soát bảo mật độc lập (đặc biệt CSRF, quyền quản trị, backup/restore, giới hạn truy cập và quy trình xử lý sự cố). Không nên coi gói mã nguồn này là đã được kiểm toán bảo mật. Cần bật backup database, giới hạn quyền truy cập, không dùng chung tài khoản, và lưu danh sách mã bình chọn an toàn.
- Kết quả hiện tại coi nguồn chưa có điểm là 0; Ban tổ chức cần chỉ công bố khi đủ số phiếu đã khóa theo kế hoạch.
- Để đổi số ứng viên ban đầu, sửa vòng lặp khởi tạo trong `server.js` hoặc dùng SQL trước khi mở bình chọn. Không sửa ứng viên sau khi đã có phiếu chính thức.
- `render.yaml` là mẫu triển khai; kiểm tra giá và chính sách hiện hành của nhà cung cấp trước khi tạo dịch vụ.
