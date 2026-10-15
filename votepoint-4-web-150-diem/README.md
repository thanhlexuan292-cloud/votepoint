# VotePoint — Bộ 4 website demo

## 4 cổng riêng
1. `01-khan-gia.html` — khán giả phân bổ đúng 150 điểm; trọng số 30%.
2. `02-ban-giam-khao.html` — Ban giám khảo chấm từng ứng viên trên thang 100; trọng số 40%.
3. `03-tien-boi.html` — các tiền bối chấm từng ứng viên trên thang 100; trọng số 30%.
4. `04-ban-to-chuc.html` — thống kê, đối soát, xếp hạng 3 giải và xuất CSV.

## Ba giải
- **Tinh Hoa Nghệ Thuật** = điểm khán giả × 30% + điểm tiền bối × 30% + điểm Ban giám khảo × 40%.
- **Dấu Ấn Khán Giả** = xếp hạng riêng theo điểm khán giả.
- **Dấu Ấn Thế Hệ** = xếp hạng riêng theo điểm trung bình của các phiếu tiền bối.

Điểm khán giả quy đổi: tổng điểm ứng viên nhận được / (số phiếu khán giả hợp lệ × 150) × 100.
Điểm tiền bối và BGK: trung bình điểm của những phiếu đã lưu cho ứng viên đó. Nguồn chưa có điểm được tính là 0 trong bảng demo; ban tổ chức cần kiểm tra tiến độ trước khi công bố.

## Chạy thử
Mở các file HTML trong trình duyệt. Để các trang đọc chung dữ liệu ổn định, nên chạy qua cùng một web server/origin (không chỉ mở từng file `file://`). Bản demo dùng localStorage, không có backend và không đồng bộ giữa các thiết bị. Có thể dùng để xem giao diện và luồng tính điểm, chưa nên dùng làm cuộc thi chính thức.

## Muốn vận hành chính thức
Cần backend/database dùng chung, tài khoản riêng cho BGK/tiền bối/ban tổ chức, mã bình chọn một lần hoặc cơ chế chống vote trùng, khóa phiếu, audit log, HTTPS, sao lưu và phân quyền.
