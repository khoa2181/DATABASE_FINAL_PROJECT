---SELECT 

--1. BÀN ĐƯỢC NGỒI NHIỀU NHẤT
SELECT TOP(1) HOADON.MABAN,GHE,TANG,CUA_SO, COUNT(HOADON.MABAN) AS SO_LUOT
FROM HOADON
JOIN BAN ON BAN.MABAN = HOADON.MABAN
GROUP BY HOADON.MABAN, GHE, TANG,CUA_SO
ORDER BY SO_LUOT DESC


--2. TOP 5 KHÁCH HÀNG CHI NHIỀU TIỀN NHẤT TRONG THÁNG 3
SELECT TOP(5) MONTH(THOIGIAN) AS THANG, KHACHHANG.MAKH, HOTEN, SUM(TRIGIA_SAU_GIAM_GIA) AS TONG_TIEN
FROM HOADON 
JOIN KHACHHANG ON KHACHHANG.MAKH = HOADON.MAKH
WHERE MONTH(THOIGIAN) = 3
GROUP BY MONTH(THOIGIAN), KHACHHANG.MAKH, HOTEN
ORDER BY TONG_TIEN DESC


--3. NHỮNG COUPON CHƯA ĐƯỢC SỬ DỤNG LẦN NÀO
SELECT COUPON.MA_COUPON, GIAM_GIA, TIEN_TOI_THIEU, TG_BATDAU, TG_KETTHUC, SD_TOI_DA 
FROM COUPON_DA_SU_DUNG
JOIN COUPON ON COUPON.MA_COUPON = COUPON_DA_SU_DUNG.MA_COUPON
GROUP BY COUPON.MA_COUPON, GIAM_GIA, TIEN_TOI_THIEU, TG_BATDAU, TG_KETTHUC, SD_TOI_DA 
HAVING SUM(SO_LAN) = 0


--4. COUPON ĐƯỢC SỬ DỤNG NHIỀU NHẤT
SELECT TOP(1) COUPON.MA_COUPON, COUNT(COUPON.MA_COUPON) AS SO_LUOT_SU_DUNG
FROM HOADON 
FULL JOIN COUPON ON HOADON.MA_COUPON = COUPON.MA_COUPON
GROUP BY COUPON.MA_COUPON
ORDER BY SO_LUOT_SU_DUNG DESC


--5. NHỮNG MÓN ĂN ĐƯỢC GỌI DƯỚI 10 LẦN
SELECT MON_AN.TEN_MON_AN, GIA, COUNT(MON_AN.TEN_MON_AN) AS SO_LUOT_GOI
FROM CTHD 
FULL JOIN MON_AN ON MON_AN.TEN_MON_AN = CTHD.TEN_MON_AN
GROUP BY MON_AN.TEN_MON_AN, GIA
HAVING COUNT(MON_AN.TEN_MON_AN) < 10
ORDER BY SO_LUOT_GOI ASC


--6. NHỮNG MÓN ĂN BÁN ĐƯỢC TRÊN SỐ LƯỢNG TRUNG BÌNH
SELECT MON_AN.TEN_MON_AN, GIA, SUM(SOLUONG) AS TONG_SO_LUONG_BAN
FROM CTHD 
JOIN MON_AN ON MON_AN.TEN_MON_AN = CTHD.TEN_MON_AN
GROUP BY MON_AN.TEN_MON_AN, GIA
HAVING SUM(SOLUONG) > (SELECT SUM(SOLUONG) / (SELECT COUNT(*) FROM MON_AN) FROM CTHD )
ORDER BY TONG_SO_LUONG_BAN DESC


--7. TÌM XEM CA LÀM NÀO KHÔNG CÓ QUẢN LÝ HOẶC ĐẦU BẾP HOẶC PHỤC VỤ
WITH QUAN_LY AS
(
	SELECT MA_CA_LAM, COUNT(MANV) AS SO_QUAN_LY
	FROM CA_LAM_NHAN_VIEN
	WHERE MANV LIKE 'QL%'
	GROUP BY MA_CA_LAM
)
,
DAU_BEP AS
(
	SELECT MA_CA_LAM, COUNT(MANV) AS SO_DAU_BEP
	FROM CA_LAM_NHAN_VIEN
	WHERE MANV LIKE 'DB%'
	GROUP BY MA_CA_LAM
)
,
PHUC_VU AS
(
	SELECT MA_CA_LAM, COUNT(MANV) AS SO_PHUC_VU
	FROM CA_LAM_NHAN_VIEN
	WHERE MANV LIKE 'PV%'
	GROUP BY MA_CA_LAM
)
SELECT CA_LAM.MA_CA_LAM, NGAY_BATDAU, NGAY_KETTHUC, CA, SO_QUAN_LY, SO_DAU_BEP, SO_PHUC_VU 
FROM DAU_BEP 
FULL JOIN QUAN_LY ON QUAN_LY.MA_CA_LAM = DAU_BEP.MA_CA_LAM 
FULL JOIN PHUC_VU ON DAU_BEP.MA_CA_LAM = PHUC_VU.MA_CA_LAM 
FULL JOIN CA_LAM ON QUAN_LY.MA_CA_LAM = CA_LAM.MA_CA_LAM
WHERE SO_QUAN_LY IS NULL OR SO_DAU_BEP IS NULL OR SO_PHUC_VU IS NULL


--8. TOP 5 KHÁCH HÀNG ĐÃ THỬ ÍT MÓN ĂN NHẤT
WITH T AS
(
	SELECT KHACHHANG.MAKH, HOTEN, SDT, TEN_MON_AN 
	FROM CTHD 
	JOIN HOADON ON HOADON.MAHD = CTHD.MAHD 
	JOIN KHACHHANG ON HOADON.MAKH = KHACHHANG.MAKH
	GROUP BY KHACHHANG.MAKH, HOTEN, SDT, TEN_MON_AN
)
SELECT TOP(5) MAKH, HOTEN, SDT,COUNT(TEN_MON_AN) AS SO_MON_DA_THU
FROM T 
GROUP BY MAKH, HOTEN, SDT
ORDER BY SO_MON_DA_THU ASC


--9. CHI TIÊU CHO NGUYÊN LIỆU NÀO NHIỀU NHẤT
SELECT TOP(1) TEN_NGUYEN_LIEU, SUM(SOLUONG) AS TONG_SO_LUONG, DON_VI, SUM(GIA) AS TONG_TRI_GIA 
FROM CHI_TIEU 
GROUP BY TEN_NGUYEN_LIEU,DON_VI
ORDER BY TONG_TRI_GIA DESC


--10. BUỔI NÀO CÓ NHIỀU NHÂN VIÊN XIN NGHỈ NHẤT 
SELECT TOP(1) CA_NGHI, COUNT(CA_NGHI) AS SO_LUONG
FROM NGAYNGHI 
GROUP BY CA_NGHI
ORDER BY SO_LUONG DESC


--11. KHUNG GIỜ NÀO CÓ NHIỀU KHÁCH NHẤT 
SELECT TOP(1) DATEPART(HOUR, THOIGIAN) AS GIO, COUNT(DATEPART(HOUR, THOIGIAN)) AS SO_HOA_DON
FROM HOADON
GROUP BY DATEPART(HOUR, THOIGIAN)
ORDER BY SO_HOA_DON DESC



