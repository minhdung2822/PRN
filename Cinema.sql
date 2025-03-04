

-- Bảng Quốc Gia (Nơi sản xuất phim)
CREATE TABLE QuocGia (
    MaQuocGia INT IDENTITY(1,1) PRIMARY KEY,
    TenQuocGia NVARCHAR(100) NOT NULL UNIQUE
);

-- Bảng Thể Loại Phim
CREATE TABLE TheLoaiPhim (
    MaTheLoai INT IDENTITY(1,1) PRIMARY KEY,
    TenTheLoai NVARCHAR(100) NOT NULL UNIQUE
);

-- Bảng Trạng Thái Phim
CREATE TABLE TrangThaiPhim (
    MaTrangThai INT IDENTITY(1,1) PRIMARY KEY,
    TenTrangThai NVARCHAR(50) NOT NULL UNIQUE,
    MoTa NVARCHAR(500)
);

-- Bảng Nhà Cung Cấp Phim
CREATE TABLE NhaCungCap (
    MaNCC NVARCHAR(50) PRIMARY KEY,
    TenCongTy NVARCHAR(100) NOT NULL,
    Logo NVARCHAR(255),
    NguoiLienLac NVARCHAR(100),
    Email NVARCHAR(100) UNIQUE NOT NULL,
    DienThoai NVARCHAR(20),
    DiaChi NVARCHAR(255),
    MoTa NVARCHAR(MAX)
);

-- Bảng Phim
CREATE TABLE Phim (
    MaPhim INT IDENTITY(1,1) PRIMARY KEY,
    TenPhim NVARCHAR(100) NOT NULL,
    DaoDien NVARCHAR(100),
    DienVien NVARCHAR(MAX),
    MoTa NVARCHAR(MAX),
    ThoiLuong INT NOT NULL, -- Phút
    Trailer NVARCHAR(255),
    Poster NVARCHAR(255),
    NgayKhoiChieu DATE NOT NULL,
    MaQuocGia INT NOT NULL,
    MaNCC NVARCHAR(50) NOT NULL,
    MaTrangThai INT NOT NULL,
    MaTheLoai INT NOT NULL,
    FOREIGN KEY (MaQuocGia) REFERENCES QuocGia(MaQuocGia) ON DELETE NO ACTION,
    FOREIGN KEY (MaNCC) REFERENCES NhaCungCap(MaNCC) ON DELETE NO ACTION,
    FOREIGN KEY (MaTrangThai) REFERENCES TrangThaiPhim(MaTrangThai) ON DELETE NO ACTION,
    FOREIGN KEY (MaTheLoai) REFERENCES TheLoaiPhim(MaTheLoai) ON DELETE NO ACTION
);

-- Bảng Phòng Chiếu
CREATE TABLE PhongChieu (
    MaPhong INT IDENTITY(1,1) PRIMARY KEY,
    TenPhong NVARCHAR(50) NOT NULL,
    SoGhe INT NOT NULL
);

-- Bảng Ghế trong Phòng Chiếu
CREATE TABLE Ghe (
    MaGhe INT IDENTITY(1,1) PRIMARY KEY,
    MaPhong INT NOT NULL,
    SoHang NVARCHAR(5) NOT NULL,
    SoCot NVARCHAR(5) NOT NULL,
    FOREIGN KEY (MaPhong) REFERENCES PhongChieu(MaPhong) ON DELETE CASCADE
);

-- Bảng Lịch Chiếu
CREATE TABLE LichChieu (
    MaLichChieu INT IDENTITY(1,1) PRIMARY KEY,
    MaPhim INT NOT NULL,
    MaPhong INT NOT NULL,
    NgayChieu DATE NOT NULL,
    GioBatDau TIME NOT NULL,
    GiaVe DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (MaPhim) REFERENCES Phim(MaPhim) ON DELETE CASCADE,
    FOREIGN KEY (MaPhong) REFERENCES PhongChieu(MaPhong) ON DELETE CASCADE
);

-- Bảng Người Dùng
CREATE TABLE NguoiDung (
    MaNguoiDung NVARCHAR(20) PRIMARY KEY,
    MatKhau NVARCHAR(50) NOT NULL,
    HoTen NVARCHAR(100) NOT NULL,
    GioiTinh BIT NOT NULL,
    NgaySinh DATE NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    DienThoai NVARCHAR(20),
    DiaChi NVARCHAR(255),
    VaiTro NVARCHAR(20) CHECK (VaiTro IN ('KhachHang', 'NhanVien', 'QuanTri')) NOT NULL,
    Hinh NVARCHAR(255) DEFAULT 'default.jpg'
);

-- Bảng Đặt Vé
CREATE TABLE DatVe (
    MaVe INT IDENTITY(1,1) PRIMARY KEY,
    MaLichChieu INT NOT NULL,
    MaNguoiDung NVARCHAR(20) NOT NULL,
    NgayDat DATE NOT NULL DEFAULT GETDATE(),
    TrangThai NVARCHAR(50) CHECK (TrangThai IN ('Đã đặt', 'Đã thanh toán', 'Đã hủy')),
    FOREIGN KEY (MaLichChieu) REFERENCES LichChieu(MaLichChieu) ON DELETE CASCADE,
    FOREIGN KEY (MaNguoiDung) REFERENCES NguoiDung(MaNguoiDung) ON DELETE CASCADE
);

-- Bảng Chi Tiết Đặt Vé
CREATE TABLE ChiTietDatVe (
    MaCT INT IDENTITY(1,1) PRIMARY KEY,
    MaVe INT NOT NULL,
    MaGhe INT NOT NULL,
    FOREIGN KEY (MaVe) REFERENCES DatVe(MaVe) ON DELETE CASCADE,
    FOREIGN KEY (MaGhe) REFERENCES Ghe(MaGhe) ON DELETE NO ACTION -- Tránh lỗi vòng lặp
);

-- Bảng Thanh Toán
CREATE TABLE ThanhToan (
    MaThanhToan INT IDENTITY(1,1) PRIMARY KEY,
    MaVe INT NOT NULL,
    SoTien DECIMAL(10,2) NOT NULL,
    PhuongThuc NVARCHAR(50) CHECK (PhuongThuc IN ('VNPay', 'MoMo', 'Tiền mặt', 'Thẻ ngân hàng')),
    NgayThanhToan DATE NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (MaVe) REFERENCES DatVe(MaVe) ON DELETE CASCADE
);

-- Bảng Thực Phẩm (Đồ uống và thức ăn)
CREATE TABLE ThucPham (
    MaThucPham INT IDENTITY(1,1) PRIMARY KEY,
    TenThucPham NVARCHAR(100) NOT NULL,
    MoTa NVARCHAR(MAX),
    Gia DECIMAL(10,2) NOT NULL,
    HinhAnh NVARCHAR(255),
    LoaiThucPham NVARCHAR(50) CHECK (LoaiThucPham IN ('Đồ uống', 'Thức ăn'))
);

-- Bảng Hóa Đơn
CREATE TABLE HoaDon (
    MaHD INT IDENTITY(1,1) PRIMARY KEY,
    MaNguoiDung NVARCHAR(20) NOT NULL,
    NgayTao DATE NOT NULL DEFAULT GETDATE(),
    TongTien DECIMAL(10,2) NOT NULL,
    PhuongThucThanhToan NVARCHAR(50) CHECK (PhuongThucThanhToan IN ('VNPay', 'MoMo', 'Tiền mặt', 'Thẻ ngân hàng')),
    TrangThai NVARCHAR(50) CHECK (TrangThai IN ('Chưa thanh toán', 'Đã thanh toán', 'Đã hủy')),
    FOREIGN KEY (MaNguoiDung) REFERENCES NguoiDung(MaNguoiDung) ON DELETE CASCADE
);

-- Bảng Chi Tiết Hóa Đơn (Lưu vé xem phim & thực phẩm)
CREATE TABLE ChiTietHoaDon (
    MaCT INT IDENTITY(1,1) PRIMARY KEY,
    MaHD INT NOT NULL,
    LoaiSanPham NVARCHAR(50) CHECK (LoaiSanPham IN ('Vé xem phim', 'Thực phẩm')),
    MaSanPham INT NOT NULL,
    SoLuong INT NOT NULL,
    Gia DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD) ON DELETE CASCADE
);
