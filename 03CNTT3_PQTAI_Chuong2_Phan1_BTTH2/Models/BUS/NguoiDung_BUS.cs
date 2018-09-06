using _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.DAO;
using _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.BUS
{
    public class NguoiDung_BUS
    {
        public static string ThemNguoiDungMoi(NguoiDung_DTO nguoidung)
        {
            nguoidung.Matkhau = MaHoaThongTin_BUS.MaHoaSHA1(nguoidung.Matkhau).ToLower();
            return NguoiDung_DAO.ThemNguoiDungMoi(nguoidung);
        }

        public static NguoiDung_DTO LayThongTinNguoiDungBoiUsernameVaPassword(string tendangnhap, string matkhau)
        {
            matkhau = MaHoaThongTin_BUS.MaHoaSHA1(matkhau).ToLower();
            return NguoiDung_DAO.LayThongTinNguoiDungBoiUsernameVaPassword(tendangnhap, matkhau);
        }
    }
}