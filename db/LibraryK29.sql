/* 
_______________________________________CƠ SỞ DỮ LIỆU THƯ VIỆN___________________________________________
@Database:		LIBRARYK29 
@Author:		Khoa Thư Viện Thông Tin Học & Quản Trị Thông Tin K29
@Date:			09/01/2016
@Version:		1.0
@Description:   Cơ sở dữ liệu cho đồ án cuối kỳ Website Library K29 
________________________________________________________________________________________________________
Note: 
1- Mọi mã trong các bảng đều là nvarchar, khi thêm một dòng động từ ứng dụng Web phải sử dụng hàm
   NEWID() xây dựng sẳn trong T-SQL. NEWID() là hàm random chuổi duy nhất trong SQL thường dùng để
   đặt tên file hay lấy id ví dụ một chuỗi được generate là '8BF5D7AA-6BF0-44CC-A361-1CC133BDB788'
   Các dữ liệu thêm tạm để testing trong script này được thêm bằng tay 1,2...
2- Kiểu nvarchar có thể chứa đoạn text nặng khoản 2 G, tức có thể chứa 1 tỉ ký tự unicode
3- Mọi dữ liệu insert vào các bảng trong này là dữ liệu demo cho testing, hoàn toàn không liên quan đến
   thông tin sách, tác giả,.... bên ngoài thế giới thực.
_______________________________________________________________________________________________________*/


/*----------------------------------TẠO CƠ SỞ DỮ LIỆU LIBRARYK29--------------------------------------*/

--Khai báo sử dụng database master
use master
go

--Nếu tồn tại database LIBRARYK29 trong hệ thống thì xóa
if exists (select * from sys.databases where name='LIBRARYK29')
begin
	drop database LIBRARYK29
end
go

--Tạo mới database có tên LIBRARYK29
create database LIBRARYK29
go

--Khai báo sử dụng Database LIBRARYK29 
use LIBRARYK29
go
/*--------------------------------CÁC LỆNH TẠO BẢNG CỦA CSDL LIBRARYK29-------------------------------*/

--Lệnh Tạo Bảng Tham Số (Dùng chứa các giá trị cấu hình cho toàn hệ thống)
create table ThamSo
(
	mathamso		nvarchar(50)	not null,
	tendulieu		nvarchar(50)	not null,
	giatridulieu	nvarchar(1000)	not null
)
go

--Lệnh Tạo Bảng Thông Báo Email (Dùng chứa các email của người dùng đăng ký nhân thông báo bằng email)
create table ThongBaoEmail
(
	mathongbaoemail	nvarchar(50)	not null,
	email			nvarchar(50)	not null,
	ngaydangky		datetime		not null
)
go

--Lệnh Tạo Bảng Nhà Xuất Bản (Chứa thông tin của các nhà xuất bản là nơi chịu trách nhiệm in ấn các đầu sách)
create table NhaXuatBan
(
	manhaxuatban	nvarchar(50)	not null,
	tennhaxuatban	nvarchar(100)	not null,
	diachi			nvarchar(1000)		null
)
go

--Lệnh Tạo Bảng Tác Giả (Chứa thông tin tác giả chính của một đầu sách, ghi chú: nếu phân tích kỹ hơn thì ta phải có bản DauSachVaTacGia để kết bảng Dau Sách và bảng Tác Giả vì một cuốn sách có thể viết bởi nhiều tác giả và ngược lại một tác giả có thể viết nhiều đầu sách (quan hệ nhiều - nhiều). Tuy nhiên, để đơn giản trong đồ án này ta chỉ xét một cuốn sách chỉ chứa thông tin của duy nhật một tác giả chính (tức quan hệ 1 - nhiều))
create table TacGia
(
	matacgia		nvarchar(50)	not null,
	tentacgia		nvarchar(100)	not null,
	namsinh			smallint			null,			-- Chỉ lưu năm sinh mà thôi. Miền giá trị của smallint là -2^15 (-32,768) to 2^15-1 (32,767)
	anhtacgia		nvarchar(100)		null,
	butdanh			nvarchar(100)		null,			-- Nếu phân tích đúng thì bút danh sẽ là một bảng khác có tên là ButDanh, vì một tác giả có thể có rất nhiều bút danh và một bút danh có thể có đồng tác giả. Do đó, có một bảng khác nữa là TacGiaVaButDanh để kết giữa bảng TacGiaVaButDanh. Tuy nhiên, trong đồ án này ta đơn giản hóa mỗi tác giả chỉ có một và chỉ một bút danh và một bút danh chỉ thuộc về một tác giả. 
	motangan		nvarchar(MAX)		null,			-- Nếu dữ liệu lưu trữ dưới 4000 kí tự thì cách lưu trữ nvarchar(MAX) <=> nvarchar(4000). Nếu lớn hơn 4000 kí tự, SQL sẽ tạo cơ chế lưu trữ khác theo con trỏ. Đó là công việc của SQL, còn chúng ta nếu ta cần lưu một lượng lớn các chử (toàn bộ chử của cả một cuốn sách) và vượt hơn 4000 ký tự thì ta khai báo nvarchar(MAX)
	luotxem			int				not null
)
go

--Lệnh Tạo Bảng Chủ Đề (Chứa thông tin chủ đề của các đầu sách có trong hệ thống, một đầu sách thuộc một chủ đề nào đó, ví dụ: Tin Học, Truyên Tranh, Ngoại Ngữ, Văn Học...)
create table ChuDe
(
	machude			nvarchar(50)	not null,
	tenchude		nvarchar(100)	not null
)
go

--Lệnh Tạo Bảng Loại Người Dùng (Chứa tên và thông tin phân quyền của người trong hệ thống như: user, member, manager, administrator)
create table LoaiNguoiDung 
(
	maloainguoidung		nvarchar(50)	not null,
	tenloainguoidung	nvarchar(100)	not null,
	phanquyen			varchar(2)		not null		--u: Người dùng thường (User-chưa đăng nhập), me: Thành viên của hệ thống (Member-đã đăng nhập), ma: Người quản trị và quản lý (Manager), a: là người quản trị hệ thống (Administrator - super admin)
)
go

--Lệnh Tạo Bảng Trạng Thái (Chứa trạng thái của đơn đặt hàng để cho biết đơn đặt hàng này đang trong tình trạng nào: được duyệt chưa? đang đọc? hay đã trả?)
create table TrangThai
(
	matrangthai			nvarchar(50)	not null,
	tentrangthai		nvarchar(100)	not null		--Có 5 trạng thái: Chưa duyệt (member đã đặt mượn sách nhưng manager chưa xem đơn này), Đang duyệt (manager đang tìm sách và làm thủ tục cho member mượn), Đã Hủy (Manager sau khi xem xét đơn mượn sách nhưng vì một vấn đề nào đó manager không chấp nhận cho member mượn sách), Đang mượn (Manager đồng ý, đã giao sách cho member và member đang mượn sách), Đã trả (Member đã đọc và đã trả sách cho thư viện)
)
go

--Lệnh Tạo Bảng Người Dùng (Chứa thông tin cá nhân của tất cả người dùng sử dụng hệ thống)
create table NguoiDung
(
	manguoidung			nvarchar(50)	not null,
	tendangnhap			nvarchar(100)	not null,
	matkhau				nvarchar(100)	not null,
	hovaten				nvarchar(100)	not null,
	diachi				nvarchar(1000)		null,
	email				nvarchar(100)		null,
	sodienthoai			nvarchar(50)		null,
	gioitinh			varchar(1)			null,		--Có 3 giá trị: G (Gái-nữ giới), T (Trai-nam giới), B (Bê đê)
	ngaysinh			date				null,		--Chỉ chứa giá trị YYYY/MM/DD không chứa thời gian hh/mm/ss
	motangan			nvarchar(MAX)		null,
	anhdaidien			nvarchar(100)		null,
	maloainguoidung		nvarchar(50)	not null,
	khoanguoidung		varchar(1)		not null		--Luôn có 1 trong 2 giá trị sau: L (Lock - user đang trong tình trạng bị quản lý khóa) và U (Unlock - user không bị khóa)					
)
go


--Lệnh Tạo Bảng Đầu Sách (Chứa thông tin các đầu sách được quản lý bởi hệ thống)
create table DauSach
(
	madausach			nvarchar(50)	not null,
	tensach				nvarchar(100)	not null,
	matacgia			nvarchar(50)	not null,
	manhaxuatban		nvarchar(50)	not	null,
	soluong				int					null,		-- Việc xác định tồn tại thật sự số lượng một tựa sách trong thư viện đôi khi khó khăn, nên chổ này mình để giá trị có thể null
	bia					nvarchar(100)		null,
	tomtat				nvarchar(MAX)		null,
	filesach			nvarchar(100)		null,		-- File pdf hay muti-media để người dùng có thể xem như book-trailer, video, mp3....
	ngaydang			datetime		not null,
	machude				nvarchar(50)	not null,
	luotxem				int				not null		
)
go

--Lệnh Tạo Bảng Đánh Giá (Bảng này chứa điểm đánh giá của người dùng (me,ma,a) đối với một đầu sách nào đó có trong hệ thống)
create table DanhGia
(
	madanhgia			nvarchar(50)	not null,
	manguoidung			nvarchar(50)	not null,
	madausach			nvarchar(50)	not null,
	diemdanhgia			int				not	null		-- Rank đánh giá trị của một người dùng cho một đầu sách thuộc 6 giá trị là (0,1,2,3,4,5), Nếu nhiều người đánh giá cho một đầu sách thì điểm đánh giá của một đầu sách được tính là điểm trung bình của tất cả những người đánh giá cho đầu sách đó. 
)
go

--Lệnh Tạo Bảng Nhận Xét (Bảng này chứa thông tin nhận xét của người dùng cho một đầu sách)
create table NhanXet
(
	manhanxet			nvarchar(50)	not null,
	manguoidung			nvarchar(50)	not null,
	madausach			nvarchar(50)	not null,
	noidung				nvarchar(4000)	not	null,
	thoidiem			datetime		not null 
)
go

--Lệnh Tạo Bảng Đơn Mượn Sách (Chứa thông tin giao dịch mượn sách của người dùng: ai mượn? thời điểm mượn.V.v...)
create table DonMuonSach
(
	madonmuonsach		nvarchar(50)	not null,
	manguoidung			nvarchar(50)	not null,
	ngaydat				datetime		not null,
	ngaymuon			datetime			null,
	ngayhentra			datetime			null,
	ngaytra				datetime			null,
	matrangthai			nvarchar(50)	not null		--Đã duyệt? chờ duyệt? đang mươn? đã trả?... Xem bảng TrangThai để biết thêm chi tiết. 
)
go

--Lệnh Tạo Bảng Chi Tiết Đơn Mượn Sách (Chứa thông tin cụ thể của đơn mượn sách... mượn sách gì? của đơn mượn sách nào? mỗi đầu sách mượn bao nhiêu cuốn)
create table ChiTietDonMuonSach
(
	machitietdonmuonsach	nvarchar(50)	not null,
	madonmuonsach			nvarchar(50)	not null,
	madausach				nvarchar(50)	not null,
	soluong					int				not null
)
go

--Lệnh Tạo Bảng Phản Hồi (Đay là bảng cho phép nhận các phản hồi của người dùng khi sử dụng hệ thống, phản hồi này được duyệt bởi administrator)
create table PhanHoi
(
	maphanhoi		nvarchar(50)	not null,
	manguoidung		nvarchar(50)		null,			-- Chú ý ở đây ta cho hai loại người dùng là member và user sử dụng luôn. Nếu khóa ngoại manguoidung tồn tại => là người dùng hệ thống và có thể biết thông tin của người dùng nào gởi do đó có thể nhập email trong bảng này tự động. Nếu manguoidung là null => đây là người dùng user (chưa đăng nhập) do đó người dùng đó phải tự nhập email, để administrator có thể liên lạc
	email			nvarchar(100)	not	null,
	ngaydang		datetime		not null,
	noidung			nvarchar(4000)	not null
)
go

/*--------------------------------CÁC LỆNH TẠO CHỈ MỤC CHO CÁC BẢNG-------------------------------------*/
/*Do một số trường thuộc tính trong bảng chúng ta thường thực hiện việc tìm kiếm như tensach trong Bảng DauSach, chính vì thế ta nên lập chỉ mục cho trường thuộc tính này để tăng việc tốc độ việc kết bảng và tìm kiếm trong các câu lệnh T-SQL */
create index AK_DauSach_tensach ON DauSach(tensach)
go

/*--------------------------------CÁC LỆNH TẠO RÀNG BUỘC KHÓA CHÍNH-----------------------------------*/

--Lệnh Tạo Ràng Buộc Khóa Chính Cho Bảng Tham Số
alter table ThamSo add constraint PK_ThamSo primary key(mathamso)
go

--Lệnh Tạo Ràng Buộc Khóa Chính Cho Bảng Thông Báo Email
alter table ThongBaoEmail add constraint PK_ThongBaoEmail primary key(mathongbaoemail)
go

--Lệnh Tạo Ràng Buộc Khóa Chính Cho Bảng Nhà Xuất Bản
alter table NhaXuatBan add constraint PK_NhaXuatBan primary key(manhaxuatban)
go

--Lệnh Tạo Ràng Buộc Khóa Chính Cho Bảng Tác Giả
alter table TacGia add constraint PK_TacGia primary key(matacgia)
go

--Lệnh Tạo Ràng Buộc Khóa Chính Cho Bảng Chủ Đề
alter table ChuDe add constraint PK_ChuDe primary key(machude)
go

--Lệnh Tạo Ràng Buộc Khóa Chính Cho Bảng Loại Người Dùng
alter table LoaiNguoiDung add constraint PK_LoaiNguoiDung primary key(maloainguoidung)
go

--Lệnh Tạo Ràng Buộc Khóa Chính Cho Bảng Trạng Thái
alter table TrangThai add constraint PK_TrangThai primary key(matrangthai)
go

--Lệnh Tạo Ràng Buộc Khóa Chính Cho Bảng Người Dùng
alter table NguoiDung add constraint PK_NguoiDung primary key(manguoidung)
go

--Lệnh Tạo Ràng Buộc Khóa Chính Cho Bảng Đầu Sách
alter table DauSach add constraint PK_DauSach primary key(madausach)
go

--Lệnh Tạo Ràng Buộc Khóa Chính Cho Bảng Đánh Giá
alter table DanhGia add constraint PK_DanhGia primary key(madanhgia)
go

--Lệnh Tạo Ràng Buộc Khóa Chính Cho Bảng Nhận Xét
alter table NhanXet add constraint PK_NhanXet primary key(manhanxet)
go

--Lệnh Tạo Ràng Buộc Khóa Chính Cho Bảng Đơn Mượn Sách
alter table DonMuonSach add constraint PK_DonMuonSach primary key(madonmuonsach)
go

--Lệnh Tạo Ràng Buộc Khóa Chính Cho Bảng Chi Tiết Đơn Mượn Sách
alter table ChiTietDonMuonSach add constraint PK_ChiTietDonMuonSach primary key(machitietdonmuonsach)
go

--Lệnh Tạo Ràng Buộc Khóa Chính Cho Bảng Phản Hồi
alter table PhanHoi add constraint PK_PhanHoi primary key(maphanhoi)
go

/*--------------------------------CÁC LỆNH TẠO RÀNG BUỘC KHÓA NGOẠI-------------------------------------*/

--Lệnh Tạo Ràng Buộc Khóa Ngoại Cho Bảng ThamSo
--Lệnh Tạo Ràng Buộc Khóa Ngoại Cho Bảng Thông Báo Email
--Lệnh Tạo Ràng Buộc Khóa Ngoại Cho Bảng Nhà Xuất Bản
--Lệnh Tạo Ràng Buộc Khóa Ngoại Cho Bảng Tác Giả
--Lệnh Tạo Ràng Buộc Khóa Ngoại Cho Bảng Chủ Đề
--Lệnh Tạo Ràng Buộc Khóa Ngoại Cho Bảng Loại Người Dùng
--Lệnh Tạo Ràng Buộc Khóa Ngoại Cho Bảng Trạng Thái
--Lệnh Tạo Ràng Buộc Khóa Ngoại Cho Bảng Người Dùng
alter table NguoiDung add constraint  FK_NguoiDung_LoaiNguoiDung foreign key (maloainguoidung) references LoaiNguoiDung(maloainguoidung)
go 

--Lệnh Tạo Ràng Buộc Khóa Ngoại Cho Bảng Đầu Sách
alter table DauSach add constraint  FK_DauSach_TacGia foreign key (matacgia) references TacGia(matacgia)
go 

alter table DauSach add constraint  FK_DauSach_NhaXuatBan foreign key (manhaxuatban) references NhaXuatBan(manhaxuatban)
go 

alter table DauSach add constraint  FK_DauSach_ChuDe foreign key (machude) references ChuDe(machude)
go 

--Lệnh Tạo Ràng Buộc Khóa Ngoại Cho Bảng Đánh Giá
alter table DanhGia add constraint  FK_DanhGia_NguoiDung foreign key (manguoidung) references NguoiDung(manguoidung)
go 

alter table DanhGia add constraint  FK_DanhGia_DauSach foreign key (madausach) references DauSach(madausach)
go 

--Lệnh Tạo Ràng Buộc Khóa Ngoại Cho Bảng Nhận Xét
alter table NhanXet add constraint  FK_NhanXet_NguoiDung foreign key (manguoidung) references NguoiDung(manguoidung)
go 

alter table NhanXet add constraint  FK_NhanXet_DauSach foreign key (madausach) references DauSach(madausach)
go 

--Lệnh Tạo Ràng Buộc Khóa Ngoại Cho Bảng Đơn Mượn Sách
alter table DonMuonSach add constraint  FK_DonMuonSach_NguoiDung foreign key (manguoidung) references NguoiDung(manguoidung)
go 

alter table DonMuonSach add constraint  FK_DonMuonSach_TrangThai foreign key (matrangthai) references TrangThai(matrangthai)
go 

--Lệnh Tạo Ràng Buộc Khóa Ngoại Cho Bảng Chi Tiết Đơn Mượn Sách
alter table ChiTietDonMuonSach add constraint  FK_ChiTietDonMuonSach_DonMuonSach foreign key (madonmuonsach) references DonMuonSach(madonmuonsach)
go 

alter table ChiTietDonMuonSach add constraint  FK_ChiTietDonMuonSach_DauSach foreign key (madausach) references DauSach(madausach)
go 

--Lệnh Tạo Ràng Buộc Khóa Ngoại Cho Bảng Phản Hồi
alter table PhanHoi add constraint  FK_PhanHoi_NguoiDung foreign key (manguoidung) references NguoiDung(manguoidung)
go 

/*--------------------------------CÁC LỆNH TẠO RÀNG BUỘC KHÁC--------------------------------------------*/
--Tao rang buoc toàn vẹn cho bảng Đánh Giá với điểm đánh giá >=0 và <=5
alter table DanhGia add constraint CK_DanhGia_diemdanhgia check(diemdanhgia >= 0 and diemdanhgia <= 5)
go

/*--------------------------------CÁC LỆNH TẠO DỮ LIỆU TẠM ĐỂ TEST---------------------------------------*/
--Thêm dữ liệu Cho Bảng ThamSo
insert into ThamSo(mathamso,tendulieu,giatridulieu) values
(N'1',N'projectname',N'Libray K29'),
(N'2',N'author',N'Quản Trị Thông Tin Khóa 29'),
(N'3',N'soluongsachmuontoida',N'3')									--Lưu trữ thông số cho luật trong thư viện, một đơn đặt mượn chỉ mượn số lượng tối đa là 3 đầu sách
go

--Thêm dữ liệu Cho Bảng Thông Báo Email

--Thêm dữ liệu Cho Bảng Nhà Xuất Bản
insert into NhaXuatBan(manhaxuatban,tennhaxuatban,diachi) values
(N'1',N'Nhà xuất bản Thông Tấn',N'120 Nguyễn Thị Minh Khai, Quận 3, TP. Hồ Chí Minh.'),
(N'2',N'Nhà Xuất Bản Văn Học',N'18 Nguyễn Trường Tộ, Quận Ba Đình, TP. Hà Nội'),
(N'3',N'Nhà xuất bản Công An Nhân Dân',N'283 Điện Biên Phủ, Quận 3, TP. Hồ Chí Minh'),
(N'4',N'Nhà xuất bản Trẻ',N'161B Lý Chính Thắng, Phường 7, Quận 3, TP. Hồ Chí Minh'),
(N'5',N'Nhà xuất bản Kim Đồng',N'268 Nguyễn ĐÌnh Chiểu, Quận I, TP. Hồ Chí Minh'),
(N'6',N'Nhà xuất bản Khoa Học Và Kỹ Thuật',N'28 Đồng Khởi, Quận I, TP. Hồ Chí Minh'),
(N'7',N'Nhà xuất bản Lao Động - Xã Hội',N'Ngõ Hoà Bình 4, Minh Khai, Hai Bà Trưng, TP. Hà Nội'),
(N'8',N'Nhà xuất bản Hà Nội',N'Số 4 Phố Tống Duy Tân, Quận Hoàn Kiếm, TP. Hà Nội'),
(N'9',N'Nhà xuất bản Tổng Hợp TP.HCM',N'62, Nguyễn Thị Minh Khai, Quận I, TP. Hồ Chí Minh'),
(N'10',N'Nhà Xuất Bản Thế Giới',N'46, Trần Hưng Đạo, TP. Hà Nội')
go

--Thêm dữ liệu Cho Bảng Tác Giả
insert into TacGia(matacgia,tentacgia,namsinh,anhtacgia,butdanh,motangan,luotxem) values
(N'1',N'Hoàng Văn Phúc',1948,N'author0001.jpg',null,N'A Khuê (1948 - 13/8/2009) tên thật Hoàng Văn Phúc, là một nhà thơ, nhạc sĩ của Việt Nam, quê ở Tứ Kỳ, Hải Dương. Ông sinh ra trong gia đình công giáo truyền thống nghệ thuật, cha là danh vĩ cầm Hoàng Liêu, anh trai là nhạc sĩ Hoàng Lương. Từ nhỏ cha ông đã bắt ông học chơi vĩ cầm một thời gian. Thời thanh niên có lúc đi chơi nhạc kiếm tiền. Khi còn nhỏ, ông sống cùng gia đình ở Quảng Ngãi, sau đó chuyển ra Đà Nẵng rồi Đồng Nai. Sau khi lập gia đình, ông làm ruộng ở Sóc Trăng khoảng 14 năm rồi quay lại sống ở Đồng Nai. Tới năm 1998, ông cùng vợ con tới Bình Phương sống cho tới khi qua đời.',0),
(N'2',N'Lê Văn Sen',1947,N'author0002.jpg',N'Lưu Thuật Anh',N'Anh Chi tên thật là Lê Văn Sen, sinh năm 1947 tại Ngọc Trạo, Thanh Hoá. Bút danh khác của ông còn có Lưu Thuật Anh. Thể loại sáng tác: thơ, truyện ngắn, tiểu thuyết.',0),
(N'3',N'Nguyễn Đức Ngọc',1943,N'author0003.jpg',N'Ly Sơn',N'Nhà thơ Anh Ngọc tên thật là Nguyễn Đức Ngọc, sinh năm 1943 tại Nghi Lộc, Nghệ An. Bút danh khác còn có Ly Sơn. Thể loại sáng tác: thơ, dịch, truyện ký. 1964-1972 dạy trường Trung cấp và Đại học Thương nghiệp, 1971-1973 là lính thông tin ở mặt trận Quảng Trị, 1973-1979 là phóng viên báo Quân đội nhân dân, từ năm 1979 là biên tập viên, cán bộ sáng tác tạp chí Văn nghệ quân đội. Hội viên Hội nhà văn Việt Nam (1980).',0),
(N'4',N'Vương Kiều Ân',1919,N'author0004.jpg',N'Hồng Anh',N'Nữ sĩ Anh Thơ (1919-2005) tên thật là Vương Kiều Ân (Vuơng là họ cha, Kiều họ mẹ). Sinh năm 1919 tại Ninh Giang (Bắc Việt). Ông thân sinh là nhà nho, đậu tú tài, làm trợ tá. Vì ông là công chức, thuyên chuyển nay đây mai đó nên con cái thường phải đổi trường luôn. Do đó, Anh Thơ thay đổi tới ba trường (Hải Dương, Thái Bình, Bắc Giang) mà vẫn chưa qua bậc tiểu học. Lười học, nhưng rất thích văn chương, tập làm thơ từ nhỏ. Thoạt đầu, lấy bút hiệu Hồng Anh, sau mới đổi thành Anh Thơ.',0),
(N'5',N'Hoà Bình Hạ',1976,N'author0005.jpg',N'Hy Giang',N'Trong các cây bút trên báo Hoa học trò, Đàm Huy Đông có vẻ đa dạng và khá độc đáo. Anh có khá nhiều bút danh, phải kể đến Hoà Bình Hạ, Hy Giang, Giang Tây, sinh ngày 26-10-1976 ở đội 4, Hoà Bình Hạ, Tân Tiến, Văn Giang, Hưng Yên. Địa chỉ này hầu như lúc nào cũng xuất hiện dưới các tác phẩm của anh. Thế nên độc giả rất dễ dàng có thể làm quen với tác giả nhờ địa chỉ "trứ danh" này. Hiện tại anh đang là giáo viên dạy toán tại Hưng Yên. Anh đã xuất bản tập truyện ngắn Thời hoa đỏ gồm hầu hết các tác phẩm đã xuất hiện trên báo Hoa học trò.',0),
(N'6',N'Đào Văn Cảng',1941,N'author0006.jpg',N'Đào Cảng',N'Đào Cảng (1941-1987) tên khai sinh là Đào Văn Cảng, sinh tại huyện Thuỷ Nguyên, thành phố Hải Phòng. Quê gốc xã Khúc Thuỷ, huyện Thanh Oai, tỉnh Hà Tây. Hội viên Hội Nhà văn Việt Nam. Đào Cảng làm thợ cơ khí trong thời kỳ giặc Mỹ đánh phá miền Bắc. Sau đó ông chuyển sang làm công tác nghiệp vụ tại cảng Hải Phòng. Thời kỳ này ông bắt đầu có nhiều thơ in trên các báo. Ngoài bốn mươi tuổi, nhưng sức khoẻ yếu, ông mất tại Hải Phòng.',0),
(N'7',N'Đào Phan Duân',1864,N'author0007.jpg',N'Biểu Xuyên',N'Đào Phan Duân (1864-1947), mang hai họ, họ bố là họ Đào, Phan là họ mẹ, hiệu là Biểu Xuyên, sinh năm 1964 ở làng Biểu Chánh, huyện Tuy Phước, đỗ cử nhân phó bảng khoa Giáp Ngọ năm Thành Thái thứ 6 (1895), từng làm Tuần phủ Khánh Hoà. Do ở Bình Định có hai vị quan to họ Đào và đều được dân kính trọng nên trong tỉnh thường dùng cách xưng hô: Đào Biểu Chánh tức Đào Phan Duân để phân biệt với Đào Vĩnh Thạnh tức Đào Tấn, dù Đào Tấn là lớp trước (sinh năm 1845).',0),
(N'8',N'Đào Phong Lan',1975,N'author0008.jpg',null,N'Đào Phong Lan sinh ngày 25/03/1975, tốt nghiệp khoá 5 trường Viết Văn Nguyễn Du, hội viên Hội Nhà văn TP. Hồ Chí Minh, sống và làm việc tại TP. Hồ Chí Minh.',0),
(N'9',N'Đặng Đức Hiển',1937,N'author0009.jpg',N'Đặng Hiển',N'Đặng Hiển tên thật là Đặng Đức Hiển, sinh năm 1937, quê quán tại Nam Định. Bút danh: Đặng Hiển. Nghề nghiệp: Giáo viên Văn, Lớp Chuyên Văn, trường PTTH Lê Quý Đôn, Hà Tây. Nhà giáo ưu tú (1999). Đã nghỉ hưu. Hội viên Hội văn học Việt Nam. Các tập thơ đã in: Trường ca đôi cánh, Hồ trong mây, Thời gian xanh, Bài thơ trên đá, Con chúng ta, Lời chào mùa thu,... Đạt các giải thưởng văn học: Báo Người giáo viên nhân dân 1961, 1990, Báo giáo dục thời đại 1998. Uỷ ban toàn quốc Liên hiệp các Hội VHNT Việt Nam 1995, 1998. Giải thưởng VHNT Nguyễn Trãi (Hà Tây 1991-1996). Có thơ trong tuyển tập thơ Việt Nam hiện đại (NXB Hội nhà văn, 1995), Tuyển tập thơ Thầy giáo và nhà trường (NXB Giáo dục, 1999), Thơ thiếu nhi chọn lọc (NXB Thanh niên, 2000),...',0),
(N'10',N'Đặng Nguyệt Anh',1948,N'author0010.jpg',null,N'Đặng Nguyệt Anh (1948-) là nhà thơ, quê ở Ninh Cường, Trực Ninh, Nam Định. Tốt nghiệp Đại học Sư phạm TP Hồ Chí Minh. Trong kháng chiến chống Mỹ, công tác ở miền Nam. Sau giải phóng, công tác ở TP Hồ Chí Minh. Là hội viên Hội nhà văn TP Hồ Chí Minh.',0)
go

--Thêm dữ liệu Cho Bảng Chủ Đề
insert ChuDe(machude,tenchude) values
(N'1',N'Sách giáo khoa'),
(N'2',N'Sách văn học'),
(N'3',N'Sách tin học'),
(N'4',N'Sách ngoại ngữ'),
(N'5',N'Sách khoa học'),
(N'6',N'Sách kinh tế'),
(N'7',N'Thời trang'),
(N'8',N'Văn hóa'),
(N'9',N'Từ điển'),
(N'10',N'Truyện Tranh')
go

--Thêm dữ liệu Cho Bảng Loại Người Dùng
insert into LoaiNguoiDung(maloainguoidung,tenloainguoidung,phanquyen) values
(N'1',N'Người dùng thường','u'),								--User
(N'2',N'Thành viên','me'),										--Member
(N'3',N'Quản lý','ma'),											--Manager
(N'4',N'Quản trị','a')											--Adminstrator
go

--Thêm dữ liệu Cho Bảng Trạng Thái
insert into TrangThai(matrangthai,tentrangthai) values
(N'1',N'Chưa duyệt'),											--Member đã đặt mượn sách nhưng manager chưa xem đơn này
(N'2',N'Đang duyệt'),											--manager đang tìm sách và làm thủ tục cho member mượn
(N'3',N'Đã hủy'),												--Manager sau khi xem xét đơn mượn sách nhưng vì một vấn đề nào đó manager không chấp nhận cho member mượn sách
(N'4',N'Đang mượn'),											--Manager đồng ý, đã giao sách cho member và member đang mượn sách
(N'5',N'Đã trả')												--Member đã đọc và đã trả sách cho thư viện
go

--Thêm dữ liệu Cho Bảng Người Dùng
/*Tạo một administrator cho hệ thống có tên đăng nhập là 'admin' và chú ý có mật khẩu là 'admin' được mã hóa 1 chiều bởi thuật toán SHA1 thành 'd033e22ae348aeb5660fc2140aec35850c4da997' (http://www.sha1-online.com/)*/
insert into NguoiDung(manguoidung,tendangnhap,matkhau,hovaten,diachi,email,sodienthoai,gioitinh,ngaysinh,motangan,anhdaidien,maloainguoidung,khoanguoidung)
values (NEWID(),N'admin',N'd033e22ae348aeb5660fc2140aec35850c4da997',N'Administrator',N'10-12 Đinh Tiên Hoàng, Phường Bến Nghé, Quận 1, TP.HCM.',N'thuvienthongtin@hcmussh.edu.vn',N'(08) 38293828',null,null,N'Người quản trị toàn bộ hệ thống Library K29',N'noimage.jpg',4,'U')
go
/*Tạo một manager cho hệ thống có tên đăng nhập là 'manager' và chú ý có pass là 'manager' được mã hóa 1 chiều bởi thuật toán SHA1 thành '1a8565a9dc72048ba03b4156be3e569f22771f23' (http://www.sha1-online.com/)*/
insert into NguoiDung(manguoidung,tendangnhap,matkhau,hovaten,diachi,email,sodienthoai,gioitinh,ngaysinh,motangan,anhdaidien,maloainguoidung,khoanguoidung)
values (NEWID(),N'manager',N'1a8565a9dc72048ba03b4156be3e569f22771f23',N'Manager',N'10-12 Đinh Tiên Hoàng, Phường Bến Nghé, Quận 1, TP.HCM.',N'thuvienthongtin@hcmussh.edu.vn',N'(08) 38293828',null,null,N'Người quản lý người dùng, đầu sách và mượn trả sách trong hệ thống Library K29',N'noimage.jpg',3,'U')
go

--Thêm dữ liệu Cho Bảng Đầu Sách
insert into DauSach(madausach,tensach,matacgia,manhaxuatban,soluong,bia,tomtat,filesach,ngaydang,machude,luotxem) values
(NEWID(),N'Yêu Và Mơ',N'1',N'1',20,N'book00001.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00001.pdf','2016-1-14 01:00:00',N'1',0),
(NEWID(),N'Người Tình Paris & Cậu Bạn Thân',N'2',N'1',20,N'book00002.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00002.pdf','2016-1-14 01:00:00',N'2',0),
(NEWID(),N'Những Ngày Tháng Đẹp Nhất',N'3',N'1',20,N'book00003.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00003.pdf','2016-1-14 01:00:00',N'3',0),
(NEWID(),N'Tôi Là Bêtô',N'4',N'1',20,N'book00004.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00004.pdf','2016-1-14 01:00:00',N'4',0),
(NEWID(),N'Văn Mới 2013',N'5',N'1',20,N'book00005.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00005.pdf','2016-1-14 01:00:00',N'5',0),
(NEWID(),N'Tiểu Sử Steve Jobs',N'6',N'1',20,N'book00006.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00006.pdf','2016-1-14 01:00:00',N'6',0),
(NEWID(),N'Thằng Quỉ, Ngày Quái Quỉ, và...',N'7',N'1',20,N'book00007.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00007.pdf','2016-1-14 01:00:00',N'7',0),
(NEWID(),N'Truyện Cổ Tích Việt Nam',N'8',N'1',20,N'book00008.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00008.pdf','2016-1-14 01:00:00',N'8',0),
(NEWID(),N'Truyện Kể Ginji',N'9',N'1',20,N'book00009.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00009.pdf','2016-1-14 01:00:00',N'9',0),
(NEWID(),N'Tháng 5',N'10',N'1',20,N'book00010.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00010.pdf','2016-1-14 01:00:00',N'10',0),
--Để in dấu ' trong chuỗi thì trước dấu ' đó ta phải dùng thêm dấu ' tức '' => ' việc thêm dấu ' để vô hiệu hóa dấu ' và báo trình phiên dịch T-SQL xem là ' là kí tự bình thường trong chuỗi không phải dấu hiệu kết thúc chuỗi.  The Timekeeper's Moon phải sửa thành The Timekeeper''s Moon mới dúng. 
(NEWID(),N'The Timekeeper''s Moon',N'1',N'2',20,N'book00011.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00011.pdf','2016-1-14 01:00:00',N'1',0),
(NEWID(),N'Truyện Cổ Tích Việt Nam',N'2',N'2',20,N'book00012.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00012.pdf','2016-1-14 01:00:00',N'2',0),
(NEWID(),N'Tôi "bị" Bố Bắt Cóc',N'3',N'2',20,N'book00013.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00013.pdf','2016-1-14 01:00:00',N'3',0),
(NEWID(),N'Truyện Cổ Tích Việt Nam',N'4',N'2',20,N'book00014.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00014.pdf','2016-1-14 01:00:00',N'4',0),
(NEWID(),N'Tình Yêu Còn Mãi',N'5',N'2',20,N'book00015.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00015.pdf','2016-1-14 01:00:00',N'5',0),
(NEWID(),N'Bí Mật Tầu Kỳ Lân',N'6',N'2',20,N'book00016.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00016.pdf','2016-1-14 01:00:00',N'6',0),
(NEWID(),N'Tí Chổi',N'7',N'2',20,N'book00017.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00017.pdf','2016-1-14 01:00:00',N'7',0),
(NEWID(),N'Yêu Trên Từng Ngón Tay',N'8',N'2',20,N'book00018.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00018.pdf','2016-1-14 01:00:00',N'8',0),
(NEWID(),N'Tay Tìm Tay Níu Tay',N'9',N'2',20,N'book00019.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00019.pdf','2016-1-14 01:00:00',N'9',0),
(NEWID(),N'Thần Đồng Đất Việt - Hoàng Sa, Trường Sa',N'10',N'2',20,N'book00020.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00020.pdf','2016-1-14 01:00:00',N'10',0),
(NEWID(),N'Anh Có Thích Nước Mỹ Không?',N'1',N'3',20,N'book00021.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00021.pdf','2016-1-14 01:00:00',N'1',0),
(NEWID(),N'Món Quà Tình Yêu',N'2',N'3',20,N'book00022.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00022.pdf','2016-1-14 01:00:00',N'2',0),
(NEWID(),N'Truyện Cổ Tích Việt Nam',N'3',N'3',20,N'book00023.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00023.pdf','2016-1-14 01:00:00',N'3',0),
(NEWID(),N'Rũ Bỏ Trần Gian',N'4',N'3',20,N'book00024.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00024.pdf','2016-1-14 01:00:00',N'4',0),
(NEWID(),N'Cung Trăng',N'5',N'3',20,N'book00025.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00025.pdf','2016-1-14 01:00:00',N'5',0),
(NEWID(),N'Quán Ngủ Ngon',N'6',N'3',20,N'book00026.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00026.pdf','2016-1-14 01:00:00',N'6',0),
(NEWID(),N'Phù Phiếm Truyện',N'7',N'3',20,N'book00027.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00027.pdf','2016-1-14 01:00:00',N'7',0),
(NEWID(),N'Crazy Girl Shin Bia',N'8',N'3',20,N'book00028.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00028.pdf','2016-1-14 01:00:00',N'8',0),
(NEWID(),N'MoMo',N'9',N'3',20,N'book00029.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00029.pdf','2016-1-14 01:00:00',N'9',0),
(NEWID(),N'Tôi Thấy Hoa Vàng Trên Cỏ Xanh',N'10',N'3',20,N'book00030.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00030.pdf','2016-1-14 01:00:00',N'10',0),
(NEWID(),N'Những Trái Tim Rực Rỡ Sắc Màu',N'1',N'4',20,N'book00031.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00031.pdf','2016-1-14 01:00:00',N'1',0),
(NEWID(),N'Một Ngày Của Bố',N'2',N'4',20,N'book00032.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00032.pdf','2016-1-14 01:00:00',N'2',0),
(NEWID(),N'Nhật Ký Một Người Cô Đơn',N'3',N'4',20,N'book00033.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00033.pdf','2016-1-14 01:00:00',N'3',0),
(NEWID(),N'Lòng Mẹ Bao La',N'4',N'4',20,N'book00034.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00034.pdf','2016-1-14 01:00:00',N'4',0),
(NEWID(),N'Nét Cười Nơi Ấy',N'5',N'4',20,N'book00035.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00035.pdf','2016-1-14 01:00:00',N'5',0),
(NEWID(),N'Này, Chớ Làm Loạn',N'6',N'4',20,N'book00036.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00036.pdf','2016-1-14 01:00:00',N'6',0),
(NEWID(),N'Một Gọt Đàn Bà',N'7',N'4',20,N'book00037.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00037.pdf','2016-1-14 01:00:00',N'7',0),
(NEWID(),N'MARC LEVY - A Primeira Noite',N'8',N'4',20,N'book00038.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00038.pdf','2016-1-14 01:00:00',N'8',0),
(NEWID(),N'Lá Rơi Trong Thành Phố',N'9',N'4',20,N'book00039.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00039.pdf','2016-1-14 01:00:00',N'9',0),
(NEWID(),N'Người Bạn Đích Thực',N'10',N'4',20,N'book00040.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00040.pdf','2016-1-14 01:00:00',N'10',0),
(NEWID(),N'Lần Đầu Biết Yêu',N'1',N'5',20,N'book00041.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00041.pdf','2016-1-14 01:00:00',N'1',0),
(NEWID(),N'Tuổi Thơ Dữ Dội',N'2',N'5',20,N'book00042.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00042.pdf','2016-1-14 01:00:00',N'2',0),
(NEWID(),N'Chào Xuân Mới',N'3',N'5',20,N'book00043.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00043.pdf','2016-1-14 01:00:00',N'3',0),
(NEWID(),N'Thương Vị Tình Yêu',N'4',N'5',20,N'book00044.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00044.pdf','2016-1-14 01:00:00',N'4',0),
(NEWID(),N'Hệ Miễn Dịch Tâm Hồn',N'5',N'5',20,N'book00045.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00045.pdf','2016-1-14 01:00:00',N'5',0),
(NEWID(),N'Truyện Thúy Kiều',N'6',N'5',20,N'book00046.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00046.pdf','2016-1-14 01:00:00',N'6',0),
(NEWID(),N'Gió Trên Đồng',N'7',N'5',20,N'book00047.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00047.pdf','2016-1-14 01:00:00',N'7',0),
(NEWID(),N'Anh Có Thích Nước Mỹ Không?',N'8',N'5',20,N'book00048.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00048.pdf','2016-1-14 01:00:00',N'8',0),
(NEWID(),N'Vô Cùng Tàn Nhẫn, Vô Cùng Yêu Thương',N'9',N'5',20,N'book00049.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00049.pdf','2016-1-14 01:00:00',N'9',0),
(NEWID(),N'Chìm Trong Cuộc Yêu',N'10',N'5',20,N'book00050.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00050.pdf','2016-1-14 01:00:00',N'10',0),
(NEWID(),N'Doraemon',N'1',N'6',20,N'book00051.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00051.pdf','2016-1-14 01:00:00',N'1',0),
(NEWID(),N'Hãy Tìm Tôi Giữa Cánh Đồng',N'2',N'6',20,N'book00052.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00052.pdf','2016-1-14 01:00:00',N'2',0),
(NEWID(),N'Đất Rừng Phương Nam',N'3',N'6',20,N'book00053.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00053.pdf','2016-1-14 01:00:00',N'3',0),
(NEWID(),N'Đợi Mãi Những Bình Minh',N'4',N'6',20,N'book00054.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00054.pdf','2016-1-14 01:00:00',N'4',0),
(NEWID(),N'160 Bài Toán Hay Cho Trẻ Em Và Người Lớn',N'5',N'6',20,N'book00055.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00055.pdf','2016-1-14 01:00:00',N'5',0),
(NEWID(),N'Khó Giữa Sài Gòn',N'6',N'6',20,N'book00056.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00056.pdf','2016-1-14 01:00:00',N'6',0),
(NEWID(),N'The Rabbit Who Wants To Fall Asleep',N'7',N'6',20,N'book00057.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00057.pdf','2016-1-14 01:00:00',N'7',0),
(NEWID(),N'Chú Bé Thất Sơn',N'8',N'6',20,N'book00058.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00058.pdf','2016-1-14 01:00:00',N'8',0),
(NEWID(),N'Chiến Binh Cầu Vòng',N'9',N'6',20,N'book00059.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00059.pdf','2016-1-14 01:00:00',N'9',0),
(NEWID(),N'Đồng Quê',N'10',N'6',20,N'book00060.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00050.pdf','2016-1-14 01:00:00',N'10',0),
(NEWID(),N'The Universe Wide Web - Getting Started',N'1',N'7',20,N'book00061.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00061.pdf','2016-1-14 01:00:00',N'1',0),
(NEWID(),N'Yêu Đi Rồi Khóc',N'2',N'7',20,N'book00062.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00062.pdf','2016-1-14 01:00:00',N'2',0),
(NEWID(),N'Nếu Như Được Làm Lại',N'3',N'7',20,N'book00063.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00063.pdf','2016-1-14 01:00:00',N'3',0),
(NEWID(),N'Đến Lượt Em Tỏ Tình',N'4',N'7',20,N'book00064.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00064.pdf','2016-1-14 01:00:00',N'4',0),
(NEWID(),N'Bẫy',N'5',N'7',20,N'book00065.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00065.pdf','2016-1-14 01:00:00',N'5',0),
(NEWID(),N'Những Cuộc Phiêu Lưu Của Nam Tước MuChauSen',N'6',N'7',20,N'book00066.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00066.pdf','2016-1-14 01:00:00',N'6',0),
(NEWID(),N'Đối Thủ Còi Cọc',N'7',N'7',20,N'book00067.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00067.pdf','2016-1-14 01:00:00',N'7',0),
(NEWID(),N'Đặc Sắc Việt Nam Từ 1986 Đến Nay',N'8',N'7',20,N'book00068.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00068.pdf','2016-1-14 01:00:00',N'8',0),
(NEWID(),N'Trái Đất Tròn Không Gì Là Không Thể',N'9',N'7',20,N'book00069.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00069.pdf','2016-1-14 01:00:00',N'9',0),
(NEWID(),N'Đừng Bao Giờ Từ Bỏ Khát Vong',N'10',N'7',20,N'book00070.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00070.pdf','2016-1-14 01:00:00',N'10',0),
(NEWID(),N'Người Đi Bán Nắng',N'1',N'8',20,N'book00071.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00071.pdf','2016-1-14 01:00:00',N'1',0),
(NEWID(),N'Chúc Một Ngày Tốt Lành',N'2',N'8',20,N'book00072.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00072.pdf','2016-1-14 01:00:00',N'2',0),
(NEWID(),N'Viết Cho Các Bà Mẹ Sanh Con Đầu Lòng',N'3',N'8',20,N'book00073.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00073.pdf','2016-1-14 01:00:00',N'3',0),
(NEWID(),N'Doraemon',N'4',N'8',20,N'book00074.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00074.pdf','2016-1-14 01:00:00',N'4',0),
(NEWID(),N'Có Ai Yêu Em Như Anh',N'5',N'8',20,N'book00075.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00075.pdf','2016-1-14 01:00:00',N'5',0),
(NEWID(),N'Tâm Nguyện RED',N'6',N'8',20,N'book00076.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00076.pdf','2016-1-14 01:00:00',N'6',0),
(NEWID(),N'SELECTION',N'7',N'8',20,N'book00077.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00077.pdf','2016-1-14 01:00:00',N'7',0),
(NEWID(),N'The Vanishing Act',N'8',N'8',20,N'book00078.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00078.pdf','2016-1-14 01:00:00',N'8',0),
(NEWID(),N'The Secret Tree',N'9',N'8',20,N'book00079.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00079.pdf','2016-1-14 01:00:00',N'9',0),
(NEWID(),N'The Secret Garden',N'10',N'8',20,N'book00080.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00080.pdf','2016-1-14 01:00:00',N'10',0),
(NEWID(),N'Raris Night - New Your Morning',N'1',N'9',20,N'book00081.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00081.pdf','2016-1-14 01:00:00',N'1',0),
(NEWID(),N'Hãy Tìm Tôi Giữa Cánh Đồng',N'2',N'9',20,N'book00082.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00082.pdf','2016-1-14 01:00:00',N'2',0),
(NEWID(),N'Tình Thiển',N'3',N'9',20,N'book00083.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00083.pdf','2016-1-14 01:00:00',N'3',0),
(NEWID(),N'Bàn Tay Nhỏ Dưới Mưa',N'4',N'9',20,N'book00084.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00084.pdf','2016-1-14 01:00:00',N'4',0),
(NEWID(),N'Alice'' Adventures In Wonderland',N'5',N'9',20,N'book00085.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00085.pdf','2016-1-14 01:00:00',N'5',0),
(NEWID(),N'Chuyện Tình Vượt Thời Gian',N'6',N'9',20,N'book00086.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00086.pdf','2016-1-14 01:00:00',N'6',0),
(NEWID(),N'SERGIO KUN AGUERO',N'7',N'9',20,N'book00087.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00087.pdf','2016-1-14 01:00:00',N'7',0),
(NEWID(),N'Xu Xu Đừng Khóc',N'8',N'9',20,N'book00088.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00088.pdf','2016-1-14 01:00:00',N'8',0),
(NEWID(),N'Dạy Con Bằng Lời Hay Ý Đẹp',N'9',N'9',20,N'book00089.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00089.pdf','2016-1-14 01:00:00',N'9',0),
(NEWID(),N'Ác Quỷ Mang Trái Tim Một Thiên Thần',N'10',N'9',20,N'book00090.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00090.pdf','2016-1-14 01:00:00',N'10',0),
(NEWID(),N'Liệu Em Có Được Hạnh Phúc',N'1',N'10',20,N'book00091.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00091.pdf','2016-1-14 01:00:00',N'1',0),
(NEWID(),N'Bong Bóng Lên Trời',N'2',N'10',20,N'book00092.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00092.pdf','2016-1-14 01:00:00',N'2',0),
(NEWID(),N'Đi Đâu Cũng Nhớ Sài Gòn Và ... Em',N'3',N'10',20,N'book00093.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00093.pdf','2016-1-14 01:00:00',N'3',0),
(NEWID(),N'Tôi Là Ai - Và Nếu Vậy Thì Bao Nhiêu?',N'4',N'10',20,N'book00094.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00094.pdf','2016-1-14 01:00:00',N'4',0),
(NEWID(),N'Không Gì Đẹp Bằng Ráng Lam Chiều',N'5',N'10',20,N'book00095.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00095.pdf','2016-1-14 01:00:00',N'5',0),
(NEWID(),N'Truyện Kiều',N'6',N'10',20,N'book00096.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00096.pdf','2016-1-14 01:00:00',N'6',0),
(NEWID(),N'Ngôi Sao Kazan',N'7',N'10',20,N'book00097.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00097.pdf','2016-1-14 01:00:00',N'7',0),
(NEWID(),N'34 Of The Most Beautiful Book Covers',N'8',N'10',20,N'book00098.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00098.pdf','2016-1-14 01:00:00',N'8',0),
(NEWID(),N'Chiếc Lọ Giáng Sinh Diệu Kỳ',N'9',N'10',20,N'book00099.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00099.pdf','2016-1-14 01:00:00',N'9',0),
(NEWID(),N'Vì Em Gặp Anh',N'10',N'10',20,N'book00100.jpg',N'Đây là dữ liệu tạm đầu sách nào cũng giống nhau. Năm hết Tết đến, Đón Khỉ tiễn Dê. Chúc ông chúc bà, chúc cha chúc mẹ , chúc cô chúc cậu, chúc chú chúc dì, chúc anh chúc chị, chúc luôn các em, chúc cả các cháu, dồi dào sức khoẻ - Có nhiều niềm vui - Tiền xu nặng túi - Tiền giấy đầy bao - Đi ăn được khao - Về nhà người rước - Tiền vô như nước - Tình vào đầy tim - Chăn ấm nệm êm - Sung sướng ban đêm - Hạnh phúc ban ngày - Luôn luôn gặp may - Suốt năm con Khỉ. :D',N'book00100.pdf','2016-1-14 01:00:00',N'10',0)
go
--Thêm dữ liệu Cho Bảng Đánh Giá
--Thêm dữ liệu Cho Bảng Nhận Xét
--Thêm dữ liệu Cho Bảng Đơn Mượn Sách
--Thêm dữ liệu Cho Bảng Chi Tiết Đơn Mượn Sách
--Thêm dữ liệu Cho Bảng Phản Hồi
/*--------------------------------CÁC LỆNH TAO STORED PROCEDURED-----------------------------------------*/

/*Lấy chủ đề sách*/
create procedure sp_LayDanhSachChuDe
as
begin
	select * from ChuDe
end
go

/*Thêm mới người dùng*/
create procedure sp_ThemNguoiDungMoi
@tendangnhap		nvarchar(100),
@matkhau			nvarchar(100),
@hovaten			nvarchar(100),
@diachi				nvarchar(1000),
@email				nvarchar(100),
@sodienthoai		nvarchar(50),
@gioitinh			varchar(1),		
@ngaysinh			date,		
@motangan			nvarchar(MAX),
@maloainguoidung	nvarchar(50),
@khoanguoidung		varchar(1),
@tenanhdaidien		nvarchar(50) output
as
begin
	declare @manguoidung nvarchar(50)
	set @manguoidung = NEWID()
	if @tenanhdaidien=N'Y'
	begin
		set @tenanhdaidien = CONCAT(NEWID(),N'.jpg')
	end
	else
	begin
		set @tenanhdaidien = N'noimage.jpg'
	end
	insert into NguoiDung(manguoidung,tendangnhap,matkhau,hovaten,diachi,email,sodienthoai,gioitinh,ngaysinh,motangan,anhdaidien,maloainguoidung,khoanguoidung)
	values (@manguoidung,@tendangnhap,@matkhau,@hovaten,@diachi,@email,@sodienthoai,@gioitinh,@ngaysinh,@motangan,@tenanhdaidien,@maloainguoidung,@khoanguoidung)
end
go

/*Đăng nhập*/
create procedure sp_LayThongTinNguoiDungBoiUsernameVaPassword
@matkhau			nvarchar(50),
@tendangnhap		nvarchar(100)
as
begin
	select * from NguoiDung nd, LoaiNguoiDung lnd where nd.maloainguoidung=lnd.maloainguoidung and nd.matkhau=@matkhau and nd.tendangnhap=@tendangnhap
end
go

/*Hàm chuyển tiếng việt có dấu sang không dấu*/
CREATE FUNCTION [dbo].[fChuyenCoDauThanhKhongDau](@inputVar NVARCHAR(MAX) )
RETURNS NVARCHAR(MAX)
AS
BEGIN    
    IF (@inputVar IS NULL OR @inputVar = '')  RETURN ''
   
    DECLARE @RT NVARCHAR(MAX)
    DECLARE @SIGN_CHARS NCHAR(256)
    DECLARE @UNSIGN_CHARS NCHAR (256)
 
    SET @SIGN_CHARS = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệếìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵýĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ' + NCHAR(272) + NCHAR(208)
    SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeeeiiiiiooooooooooooooouuuuuuuuuuyyyyyAADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD'
 
    DECLARE @COUNTER int
    DECLARE @COUNTER1 int
   
    SET @COUNTER = 1
    WHILE (@COUNTER <= LEN(@inputVar))
    BEGIN  
        SET @COUNTER1 = 1
        WHILE (@COUNTER1 <= LEN(@SIGN_CHARS) + 1)
        BEGIN
            IF UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1,1)) = UNICODE(SUBSTRING(@inputVar,@COUNTER ,1))
            BEGIN          
                IF @COUNTER = 1
                    SET @inputVar = SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@inputVar, @COUNTER+1,LEN(@inputVar)-1)      
                ELSE
                    SET @inputVar = SUBSTRING(@inputVar, 1, @COUNTER-1) +SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@inputVar, @COUNTER+1,LEN(@inputVar)- @COUNTER)
                BREAK
            END
            SET @COUNTER1 = @COUNTER1 +1
        END
        SET @COUNTER = @COUNTER +1
    END
    -- SET @inputVar = replace(@inputVar,' ','-')
    RETURN @inputVar
END
GO

/*Số lượng sách tìm kiếm được*/
create procedure sp_SoLuongSachTimKiemDuoc
@khoa nvarchar(100)
as
begin
	select count(*) from DauSach where dbo.fChuyenCoDauThanhKhongDau(tensach) like N'%'+dbo.fChuyenCoDauThanhKhongDau(@khoa)+'%'
end
go

/*Tìm kiếm và phân trang*/
create procedure sp_TimKiemSachVaPhanTrang
@khoa nvarchar(100),
@sosachtrongmottrang int,
@tranghientai int,
@cotsapxep nvarchar(100)
as
begin
	if @cotsapxep=N'ngaydang'
	begin
		select madausach, tensach, bia, tentacgia from (
			select * from DauSach where dbo.fChuyenCoDauThanhKhongDau(tensach) like N'%'+dbo.fChuyenCoDauThanhKhongDau(@khoa)+'%' order by ngaydang desc
			offset ((@tranghientai - 1) * @sosachtrongmottrang) 
			rows fetch next @sosachtrongmottrang rows only
		) ds, TacGia tg, NhaXuatBan nxb, ChuDe cd
		where ds.matacgia = tg.matacgia and ds.manhaxuatban = nxb.manhaxuatban and ds.machude = cd.machude
	end
	else if @cotsapxep=N'tensach'
	begin
		select madausach, tensach, bia, tentacgia from (
			select * from DauSach where dbo.fChuyenCoDauThanhKhongDau(tensach) like N'%'+dbo.fChuyenCoDauThanhKhongDau(@khoa)+'%' order by tensach asc 
			offset ((@tranghientai - 1) * @sosachtrongmottrang) 
			rows fetch next @sosachtrongmottrang rows only
		) ds, TacGia tg, NhaXuatBan nxb, ChuDe cd
		where ds.matacgia = tg.matacgia and ds.manhaxuatban = nxb.manhaxuatban and ds.machude = cd.machude
	end
	else if @cotsapxep=N'matacgia'
	begin
		select madausach, tensach, bia, tentacgia from (
			select * from DauSach where dbo.fChuyenCoDauThanhKhongDau(tensach) like N'%'+dbo.fChuyenCoDauThanhKhongDau(@khoa)+'%' order by matacgia desc 
			offset ((@tranghientai - 1) * @sosachtrongmottrang) 
			rows fetch next @sosachtrongmottrang rows only
		) ds, TacGia tg, NhaXuatBan nxb, ChuDe cd
		where ds.matacgia = tg.matacgia and ds.manhaxuatban = nxb.manhaxuatban and ds.machude = cd.machude
	end
	else if @cotsapxep=N'manhaxuatban'
	begin
		select madausach, tensach, bia, tentacgia from (
			select * from DauSach where dbo.fChuyenCoDauThanhKhongDau(tensach) like N'%'+dbo.fChuyenCoDauThanhKhongDau(@khoa)+'%' order by manhaxuatban asc 
			offset ((@tranghientai - 1) * @sosachtrongmottrang) 
			rows fetch next @sosachtrongmottrang rows only
		) ds, TacGia tg, NhaXuatBan nxb, ChuDe cd
		where ds.matacgia = tg.matacgia and ds.manhaxuatban = nxb.manhaxuatban and ds.machude = cd.machude
	end
	else
	begin
		select madausach, tensach, bia, tentacgia from (
			select * from DauSach where dbo.fChuyenCoDauThanhKhongDau(tensach) like N'%'+dbo.fChuyenCoDauThanhKhongDau(@khoa)+'%' order by ngaydang desc
			offset ((@tranghientai - 1) * @sosachtrongmottrang) 
			rows fetch next @sosachtrongmottrang rows only
		) ds, TacGia tg, NhaXuatBan nxb, ChuDe cd
		where ds.matacgia = tg.matacgia and ds.manhaxuatban = nxb.manhaxuatban and ds.machude = cd.machude
	end
end --exec sp_TimKiemSachVaPhanTrang N'tí',10,1,N'ngaydang'
go

/*Số lượng sách trong hệ thống*/
create procedure sp_SoLuongSachCoTrongHeThong
as
begin
	select COUNT(*) from DauSach
end
go

/*Duyệt Kho Phân Trang*/
create procedure sp_DuyetKhoSachPhanTrang
@sosachtrongmottrang int,
@tranghientai int,
@cotsapxep nvarchar(100)
as
begin
	if @cotsapxep=N'ngaydang'
	begin
		select madausach, tensach, bia, tentacgia from (
			select * from DauSach order by ngaydang desc
			offset ((@tranghientai - 1) * @sosachtrongmottrang) 
			rows fetch next @sosachtrongmottrang rows only
		) ds, TacGia tg, NhaXuatBan nxb, ChuDe cd
		where ds.matacgia = tg.matacgia and ds.manhaxuatban = nxb.manhaxuatban and ds.machude = cd.machude
	end
	else if @cotsapxep=N'tensach'
	begin
		select madausach, tensach, bia, tentacgia from (
			select * from DauSach order by tensach asc 
			offset ((@tranghientai - 1) * @sosachtrongmottrang) 
			rows fetch next @sosachtrongmottrang rows only
		) ds, TacGia tg, NhaXuatBan nxb, ChuDe cd
		where ds.matacgia = tg.matacgia and ds.manhaxuatban = nxb.manhaxuatban and ds.machude = cd.machude
	end
	else if @cotsapxep=N'matacgia'
	begin
		select madausach, tensach, bia, tentacgia from (
			select * from DauSach order by matacgia desc 
			offset ((@tranghientai - 1) * @sosachtrongmottrang) 
			rows fetch next @sosachtrongmottrang rows only
		) ds, TacGia tg, NhaXuatBan nxb, ChuDe cd
		where ds.matacgia = tg.matacgia and ds.manhaxuatban = nxb.manhaxuatban and ds.machude = cd.machude
	end
	else if @cotsapxep=N'manhaxuatban'
	begin
		select madausach, tensach, bia, tentacgia from (
			select * from DauSach order by manhaxuatban asc 
			offset ((@tranghientai - 1) * @sosachtrongmottrang) 
			rows fetch next @sosachtrongmottrang rows only
		) ds, TacGia tg, NhaXuatBan nxb, ChuDe cd
		where ds.matacgia = tg.matacgia and ds.manhaxuatban = nxb.manhaxuatban and ds.machude = cd.machude
	end
	else
	begin
		select madausach, tensach, bia, tentacgia from (
			select * from DauSach order by ngaydang desc
			offset ((@tranghientai - 1) * @sosachtrongmottrang) 
			rows fetch next @sosachtrongmottrang rows only
		) ds, TacGia tg, NhaXuatBan nxb, ChuDe cd
		where ds.matacgia = tg.matacgia and ds.manhaxuatban = nxb.manhaxuatban and ds.machude = cd.machude
	end
end
go

/*Top 10 Sách*/
create procedure sp_Top10DauSachXemNhieuNhat
as
begin
	select madausach, tensach, bia, tentacgia from 
			(select Top(10)* from DauSach order by luotxem desc) as ds, 
			TacGia tg, NhaXuatBan nxb, ChuDe cd
		where ds.matacgia = tg.matacgia and ds.manhaxuatban = nxb.manhaxuatban and ds.machude = cd.machude
end
go --exec sp_Top10DauSachXemNhieuNhat

/*Số lượng sách trong 1 chủ đề*/
create procedure sp_SoLuongSachCoTrongHeThongCuaMotChuDe
@machude nvarchar(50)
as
begin
	select COUNT(*) from DauSach where machude=@machude
end
go

/*Lấy thông tin chủ đề*/
create procedure sp_LayThongTinChiTietChuDeBoiMa
@machude nvarchar(50)
as
begin
	select * from ChuDe where machude=@machude
end
go

/*Duyệt sách theo chủ đề*/
create procedure sp_DuyetKhoSachTheoChuDePhanTrang
@machude nvarchar(50),
@sosachtrongmottrang int,
@tranghientai int,
@cotsapxep nvarchar(100)
as
begin
	if @cotsapxep=N'ngaydang'
	begin
		select madausach, tensach, bia, tentacgia from (
			select * from DauSach where machude=@machude order by ngaydang desc
			offset ((@tranghientai - 1) * @sosachtrongmottrang) 
			rows fetch next @sosachtrongmottrang rows only
		) ds, TacGia tg, NhaXuatBan nxb, ChuDe cd
		where ds.matacgia = tg.matacgia and ds.manhaxuatban = nxb.manhaxuatban and ds.machude = cd.machude
	end
	else if @cotsapxep=N'tensach'
	begin
		select madausach, tensach, bia, tentacgia from (
			select * from DauSach where machude=@machude order by tensach asc 
			offset ((@tranghientai - 1) * @sosachtrongmottrang) 
			rows fetch next @sosachtrongmottrang rows only
		) ds, TacGia tg, NhaXuatBan nxb, ChuDe cd
		where ds.matacgia = tg.matacgia and ds.manhaxuatban = nxb.manhaxuatban and ds.machude = cd.machude
	end
	else if @cotsapxep=N'matacgia'
	begin
		select madausach, tensach, bia, tentacgia from (
			select * from DauSach where machude=@machude order by matacgia desc 
			offset ((@tranghientai - 1) * @sosachtrongmottrang) 
			rows fetch next @sosachtrongmottrang rows only
		) ds, TacGia tg, NhaXuatBan nxb, ChuDe cd
		where ds.matacgia = tg.matacgia and ds.manhaxuatban = nxb.manhaxuatban and ds.machude = cd.machude
	end
	else if @cotsapxep=N'manhaxuatban'
	begin
		select madausach, tensach, bia, tentacgia from (
			select * from DauSach where machude=@machude order by manhaxuatban asc 
			offset ((@tranghientai - 1) * @sosachtrongmottrang) 
			rows fetch next @sosachtrongmottrang rows only
		) ds, TacGia tg, NhaXuatBan nxb, ChuDe cd
		where ds.matacgia = tg.matacgia and ds.manhaxuatban = nxb.manhaxuatban and ds.machude = cd.machude
	end
	else
	begin
		select madausach, tensach, bia, tentacgia from (
			select * from DauSach where machude=@machude order by ngaydang desc
			offset ((@tranghientai - 1) * @sosachtrongmottrang) 
			rows fetch next @sosachtrongmottrang rows only
		) ds, TacGia tg, NhaXuatBan nxb, ChuDe cd
		where ds.matacgia = tg.matacgia and ds.manhaxuatban = nxb.manhaxuatban and ds.machude = cd.machude
	end
end
go

/*Top 10 sách theo chủ đề*/
create procedure sp_Top10DauSachXemNhieuNhatTheoMaChuDe
@machude nvarchar(50)
as
begin
	select madausach, tensach, bia, tentacgia from 
			(select Top(10)* from DauSach where machude=@machude order by luotxem desc) as ds, 
			TacGia tg, NhaXuatBan nxb, ChuDe cd
		where ds.matacgia = tg.matacgia and ds.manhaxuatban = nxb.manhaxuatban and ds.machude = cd.machude
end
go