CREATE DATABASE QLRAPCHIEUPHIM
ON (NAME = QLRCP_DATA, FILENAME = 'D:\CSDL\QLRAPCHIEUP.MDF')
LOG ON (NAME = QLRCP_LOG, FILENAME = 'D:\CSDL\QLRAPCHIEUP.DF')

CREATE TABLE PHIM
(	MAPHIM char(3) PRIMARY KEY, 
	MADP char(3), 
	MALP char(3), 
	TENPHIM nvarchar(50) not null, 
	NSX date
)
CREATE TABLE LOAIPHIM
(	MALP char(3) primary key,
	TENLP char(2) check(TENLP in ('2D', '3D', '4D'))

)
CREATE TABLE DANGPHIM
(	MADP char(3) primary key, 
	TENDP nvarchar(50)
)

CREATE TABLE GHE 
(	
	MAGHE char(3) primary key, 
	TRANGTHAI nvarchar(10)
	)
CREATE TABLE VE
(	MAVE char(3) primary key,
	MALV char(3),
	MAPHIM char(3), 
	MAGHE char(3), 
	NGAYBANVE date,
	NGAYDATVE date

)
CREATE TABLE LOAIVE
(	MALV char(3) primary key,
	GIAVE bigint, 
	TENLV nvarchar(10)
)

CREATE TABLE CHITIETCHIEUPHIM
(	
	MAPHIM char(3) , 
	MAVE char(3), 
	primary key(MAPHIM, MAVE),
	MAPHONG char(3), 
	NGAYXUATCHIEU date, 
	GIOXUATCHIEU time

)
CREATE TABLE PHONG( 
	MAPHONG char(3) primary key, 
	SOPHONG char(4), 
	TRANGTHAI nvarchar(30) 
	)

CREATE TABLE BANGDICHVU(
	MADV char(3) primary key, 
	TENDV nvarchar(20), 
	GIADV bigint, 
	DONVITINH nvarchar(3), 
	TRANGTHAIDV nvarchar(10)
	)
CREATE TABLE NHANVIEN(
	MANV varchar(10) primary key, 
	HOLOT nvarchar(30), 
	TENNV nvarchar(10),
	NGAYSINH date,
	PHAI nvarchar(3)check(PHAI in ('Nam', N'Nữ')),
	SDT char(10),
	DIACHITTP nvarchar(20), 
	CHUCVU nvarchar(20)
	)
CREATE TABLE HOADON(
	SOHD varchar(4)primary key, 
	MAKH char(3),
	MADV char(3),
	MAVE char(3), 
	MANV varchar(10), 
	NOIDUNG nvarchar(50), 
	TRANGTHAIHD nvarchar(20), 
	THANHTIEN bigint,
	NGAYSDDV DATE
)
CREATE TABLE CTSDDV(
	MADV char(3), 
	SOHD varchar(4),
	primary key(MADV,SOHD),
	SOLUONG int, 
	THOIGIAN datetime
	)

CREATE TABLE KHACHHANG(
	MAKH char(3) primary key, 
	CMND char(9), 
	SDT char(10) not null check (len(SDT) >=8 and len(SDT) <=10 ),
	HOLOT nvarchar(30),
	TENKH nvarchar(10), 
	NGAYSINH date,
	DIACHITTP nvarchar(20)
	)
CREATE TABLE CTKH(
	CMND char(9) primary key, 
	NGAYCAP date, 
	NOICAP nvarchar(20) 
)

ALTER TABLE PHIM
ADD CONSTRAINT FK_PHIM_LP FOREIGN KEY(MALP) REFERENCES LOAIPHIM(MALP)
ALTER TABLE PHIM
ADD CONSTRAINT FK_PHIM_DP FOREIGN KEY(MADP) REFERENCES DANGPHIM(MADP) 

ALTER TABLE VE
ADD CONSTRAINT FK_VE_LV FOREIGN KEY(MALV) REFERENCES LOAIVE(MALV)
ALTER TABLE VE
ADD CONSTRAINT FK_VE_PHIM FOREIGN KEY(MAPHIM) REFERENCES PHIM(MAPHIM)
ALTER TABLE VE
ADD CONSTRAINT FK_VE_GHE FOREIGN KEY(MAGHE) REFERENCES GHE(MAGHE)

ALTER TABLE CHITIETCHIEUPHIM
ADD CONSTRAINT FK_CTCP_MP FOREIGN KEY(MAPHIM) REFERENCES PHIM(MAPHIM)
ALTER TABLE CHITIETCHIEUPHIM
ADD CONSTRAINT FK_CTCP_MV FOREIGN KEY(MAVE) REFERENCES VE(MAVE) on update cascade on delete no action
	
ALTER TABLE CHITIETCHIEUPHIM
ADD CONSTRAINT FK_CTCP_MPHONG FOREIGN KEY(MAPHONG) REFERENCES PHONG(MAPHONG)

ALTER TABLE HOADON
ADD CONSTRAINT FK_HD_MV FOREIGN KEY(MAVE) REFERENCES VE(MAVE)
ALTER TABLE HOADON
ADD CONSTRAINT FK_HD_MNV FOREIGN KEY(MANV) REFERENCES NHANVIEN(MANV)
ALTER TABLE HOADON
ADD CONSTRAINT FK_HD_MKH FOREIGN KEY(MAKH) REFERENCES KHACHHANG(MAKH) on update cascade 
ALTER TABLE HOADON
ADD CONSTRAINT FK_HD_MDV FOREIGN KEY(MADV) REFERENCES BANGDICHVU(MADV)


ALTER TABLE CTSDDV
ADD CONSTRAINT FK_CTSDV_MDV FOREIGN KEY(MADV) REFERENCES BANGDICHVU(MADV) on update cascade on delete cascade
ALTER TABLE CTSDDV
ADD CONSTRAINT FK_CTSDV_HD FOREIGN KEY(SOHD) REFERENCES HOADON(SOHD) on update cascade on delete cascade

ALTER TABLE KHACHHANG
ADD CONSTRAINT FK_KH_CTKH FOREIGN KEY(CMND) REFERENCES CTKH(CMND) 

ALTER TABLE VE
ADD CONSTRAINT PK_NGAYBANVE_NGAYDATVE CHECK(NGAYBANVE >= NGAYDATVE)
ALTER TABLE BANGDICHVU
ADD CONSTRAINT K_GIADV CHECK(GIADV > 0)
ALTER TABLE NHANVIEN
ADD CONSTRAINT K_SDTNV check(len(SDT) >=8 and len(SDT) <=10 )
ALTER TABLE CTSDDV
ADD CONSTRAINT K_SOLUONG check(SOLUONG > 0 )
III. Xây dựng các câu lệnh thực thi và giải thích rõ nghĩa các View, Function, Stored Procedure, Trigger…để thực thi các chức năng của phần mềm.

+THỰC THI CÂU LỆNH VỚI VIEW:
-- HIỂN THỊ TÊN PHIM, DẠNG PHIM, LOẠI PHIM VÀ NGÀY SẢN XUẤT
CREATE VIEW CTPhim 
AS
	select TENPHIM, TENDP as [Dạng Phim], TENLP as [Loại Phim]
	from PHIM p, DANGPHIM d, LOAIPHIM l
	where p.MADP = d.MADP and l.MALP = p.MALP

câu lệnh thực thi: select * from CTPhim
-- IN RA TÊN KHÁCH HÀNG VÀ SỐ LẦN MUA HÀNG, NẾU CHƯA MUA THÌ GHI 0
CREATE VIEW InKH
AS
select K.MAKH, TENKH, count(H.MAKH) as [Số lần mua hàng]
from KHACHHANG K left join HOADON H
on K.MAKH=H.MAKH
group by K.MAKH, TENKH

câu lệnh thực thi: select * from InKH

--HIỂN THỊ DANH SÁCH CÁC DỊCH VỤ GỒM MÃ DỊCH VỤ, TÊN DV, ĐƠN VỊ TÍNH VÀ GIÁ MUA MÀ CÓ GIÁ MUA TRÊN 20000.
CREATE VIEW CTDV
AS
	select MADV, TENDV ,DONVITINH ,GIADV
	from BANGDICHVU
	where GIADV >= '20000' 

câu lệnh thực thi: select * from CTDV
-- HIỂN THỊ TÊN NHÂN VIÊN VÀ TỔNG SỐ VÉ BÁN ĐƯỢC 
CREATE VIEW TVeBandc
AS
	select n.MANV, (HOLOT +' ' +TENNV) [Họ Tên],count(h.MAVE) [Tổng vé bán được]
	from NHANVIEN n, HOADON h
	where h.MANV = n.MANV 
	group by n.MANV,(HOLOT +' ' +TENNV)

câu lệnh thực thi: select * from TVeBandc
CREATE VIEW NVseller
AS
-- HIỂN THỊ TÊN NHÂN VIÊN VÀ TỔNG SỐ VÉ BÁN ĐƯỢC LÀ VÉ VIP
	select n.MANV, (HOLOT +' ' +TENNV) [Họ Tên],count(h.MAVE) [Tổng vé VIP bán được]
	from NHANVIEN n, HOADON h, VE v, LOAIVE l
	where h.MANV = n.MANV  and h.MAVE = v.MAVE and v.MALV = l.MALV and TENLV = 'Vip'
	group by n.MANV,(HOLOT +' ' +TENNV)

câu lệnh thực thi: select * from NVseller

+THỰC THI CÂU LỆNH VỚI HÀM FUNCTION:

--VIẾT HÀM TÍNH DOANH THU CỦA THÁNG VỚI THÁNG LÀ THAM SỐ TRUYỀN VÀO.
create function TinhDoanhThu(@Thang int)
returns float
as
begin
	declare @tong float
	select @tong=sum((SOLUONG * GIADV) + GIAVE)
	from BANGDICHVU D, CTSDDV C, HOADON H, VE v, LOAIVE l
	where D.MADV = H.MADV and H.SOHD=C.SOHD and v.MALV = l.MALV and H.MAVE = v.MAVE
	and month(NGAYSDDV)=@Thang
	return isnull(@tong, 0)		
end
câu lệnh thực thi: select dbo.TinhDoanhThu(1) as [Doanh Thu theo tháng]

-- VIÊT CHƯƠNG TRÌNH IN RA TÊN DỊCH VỤ CÙNG VỚI TỔNG DOANH THU DỊCH VỤ ĐÓ THEO THÁNG VỚI MADV, THÁNG LÀ THAM SỐ TRUYỀN VÀO
create function DoanhThuDV (@thang int, @MADV char(3))
returns table
as
return(
	select TENDV, sum(SOLUONG*GIADV) [Tổng Doanh Thu Tháng]
	from BANGDICHVU b, CTSDDV c, HOADON h
	where c.MADV = h.MADV and c.SOHD = h.SOHD and c.MADV = b.MADV and MONTH(NGAYSDDV) = @thang and h.MADV = @MADV
	group by TENDV
	)
câu lệnh thực thi: select * from dbo.DoanhThuDV('4', 'DV1')
--VIẾT CHƯƠNG TRÌNH CON IN RA TÊN KH CÙNG MÃ HÓA ĐƠN VÀ SỐ TIỀN MÀ KH ĐÓ ĐÃ MUA, VỚI MÃ KHÁCH HÀNG LÀ THAM SỐ TRUYỀN VÀO.
create function INKHDAMUA(@MAKH varchar(3))
returns table
as
	return select TENKH, H.SOHD, SUM((SOLUONG * GIADV) + GIAVE) AS THANHTIEN
			from KHACHHANG K, HOADON H,BANGDICHVU D, CTSDDV C, VE V, LOAIVE L
			where K.MAKH=H.MAKH and H.MAKH=@MAKH AND D.MADV = H.MADV and H.SOHD=C.SOHD and v.MALV = l.MALV and H.MAVE = v.MAVE 
			GROUP BY TENKH, H.SOHD

câu lệnh thực thi: select * from dbo.INKHDAMUA('K04')

+THỰC THI CÂU LỆNH VỚI STORED PROCEDURE:
--IN RA DOANH THU TỔNG DỊCH VỤ (KHÔNG TÍNH TIỀN VÉ) THEO THÁNG X VỚI MÃ PHIM Y - X,YLÀ THAM SỐ TRUYỀN VÀO

create proc SumDoanhthu @x int, @y char(3)
as
	select TENPHIM, TENDV, sum(SOLUONG*GIADV) [Tổng Dịch vụ]
	from CHITIETCHIEUPHIM c, PHIM p, HOADON h, BANGDICHVU b, CTSDDV ct
	where c.MAPHIM = p.MAPHIM and c.MAVE = h.MAVE and b.MADV = ct.MADV and h.MADV = ct.MADV and month(NGAYSDDV) = @x and p.MAPHIM = @y
	group by TENPHIM,TENDV

câu lệnh thực thi: exec SumDoanhthu 1, P03
--LẤY RA DANH SÁCH X KHÁCH HÀNG CÓ TỔNG TRỊ THÀNH TIỀN LỚN NHẤT(X LÀ THAM SỐ).
create proc TopXkhang @X int
as
	select top (@X) with ties
	TENKH, SUM((SOLUONG * GIADV) + GIAVE) AS THANHTIEN
	from KHACHHANG K, HOADON H,BANGDICHVU D, CTSDDV C, VE V, LOAIVE L
	where K.MAKH=H.MAKH AND D.MADV = H.MADV and H.SOHD=C.SOHD and v.MALV = l.MALV and H.MAVE = v.MAVE 
	GROUP BY h.MAKH,TENKH
	order by [THANHTIEN] desc

câu lệnh thực thi: exec TopXkhang 4
-- Tính tổng tiền x loại vé, với x là tham số truyền vào ( Loại vé 'Thường' hoặc loại vé 'Vip')

create proc sumXVe @x nvarchar(10)
as
	select TenLV, count(h.MAVE) * GIAVE [Tổng tiền theo loại vé]
	from VE v, LOAIVE l, HOADON h
	where v.MALV = l.MALV and h.MAVE = v.MAVE and l.TENLV = @x
	group by TENLV, GIAVE

câu lệnh thực thi: exec sumXVe VIP

+ THỰC THI CÂU LỆNH VỚI TRIGGER:
-- TẠO RA TRIGGER KIỂM TRA NẾU GHẾ ĐÃ ĐƯỢC ĐẶT CÓ CÙNG MÃ PHIM VÀ NGÀY CHIẾU PHIM THÌ BÁO LỖI

ALTER TRIGGER checkGhe on VE
for insert, update
as
	declare @MAVE char(3) ,@maghe char(3), @maphim char(3), @ngatbanve date
	select @maghe = MAGHE, @maphim = MAPHIM, @MAVE = MAVE, @ngatbanve = NGAYBANVE from inserted 
	if exists (
		select MAGHE
		from Ve  
		where MAVE <> @MAVE and MAGHE = @maghe and MAPHIM = @maphim and NGAYBANVE = @ngatbanve
		)
	begin
		print N'Ghế này đã tồn tại'
		rollback tran
End
-- Xây Dựng Trigger Kiểm Tra Khách Hàng Đặt Vé Có Bị Trùng Hay Không
alter trigger checkHD on HOADON
for insert, update
as
	declare @sohd varchar(4), @ve char(3), @NGAYSDDV date
	select @sohd = SOHD, @ve = MAVE, @NGAYSDDV = NGAYSDDV from inserted 
	if exists (
		select MAVE 
		from HOADON
		where SOHD <> @sohd and MAVE = @ve and NGAYSDDV = @NGAYSDDV
	)
	begin
		print N'vé này đã được đặt'
		rollback tran
End
--HÃY XÂY DỰNG TRIGGER TỰ ĐỘNG CẬP NHẬT CỘT THANHTIEN CỦA HOADON KHI USER NHẬP MỘT HÓA ĐƠN

update HOADON
set THANHTIEN = (select (SOLUONG * GIADV+ GIAVE) [Thành Tiền]
				from BANGDICHVU b, CTSDDV c, HOADON h, VE v, LOAIVE l
				where v.MALV = l.MALV and v.MAVE = h.MAVE and c.MADV = h.MADV and b.MADV = c.MADV and c.SOHD = h.SOHD and h.SOHD = HOADON.SOHD
				)

UPDATE HOADON
SET THANHTIEN = NULL

---
DROP TRIGGER ttUP
alter trigger ttUP on HOADON
for insert, update 
as
	declare @Ma varchar(4)
	select @Ma = SOHD from inserted
	update HOADON
set THANHTIEN = (select (SOLUONG * GIADV+ GIAVE) [Thành Tiền]
from BANGDICHVU b, CTSDDV c, HOADON h, VE v, LOAIVE l
where v.MALV = l.MALV and v.MAVE = h.MAVE 
and c.MADV = h.MADV and b.MADV = c.MADV 
and c.SOHD = h.SOHD and h.SOHD = @Ma
)
where HOADON.SOHD = @Ma