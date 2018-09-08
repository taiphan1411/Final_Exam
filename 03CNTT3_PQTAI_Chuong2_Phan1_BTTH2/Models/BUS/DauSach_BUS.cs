using _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.BUS
{
    public class DauSach_BUS
    {
        public static int SoLuongSachCoTrongHeThong()
        {
            return DAO.DauSach_DAO.SoLuongSachCoTrongHeThong();
        }
        public static List<DauSachFull_DTO> DuyetKhoSachPhanTrang(int sosachtrongmottrang, int tranghientai, string cotsapxep)
        {
            return DAO.DauSach_DAO.DuyetKhoSachPhanTrang(sosachtrongmottrang, tranghientai, cotsapxep);
        }
        public static List<DauSach_DTO> Top10DauSachXemNhieuNhat()
        {
            return DAO.DauSach_DAO.Top10DauSachXemNhieuNhat();
        }
        public static int SoLuongSachCoTrongHeThongCuaMotChuDe(string machude)
        {
            return DAO.DauSach_DAO.SoLuongSachCoTrongHeThongCuaMotChuDe(machude);
        }
        public static List<DauSachFull_DTO> DuyetKhoSachTheoChuDePhanTrang(string machude, int sosachtrongmottrang, int tranghientai, string cotsapxep)
        {
            return DAO.DauSach_DAO.DuyetKhoSachTheoChuDePhanTrang(machude, sosachtrongmottrang, tranghientai, cotsapxep);
        }
        public static List<DauSach_DTO> Top10DauSachXemNhieuNhatTheoMaChuDe(string machude)
        {
            return DAO.DauSach_DAO.Top10DauSachXemNhieuNhatTheoMaChuDe(machude);
        }
        public static int SoLuongSachTimKiemDuoc(string khoa)
        {
            return DAO.DauSach_DAO.SoLuongSachTimKiemDuoc(khoa);
        }
        public static List<DauSachFull_DTO> TimKiemSachVaPhanTrang(string khoa, int sosachtrongmottrang, int tranghientai, string cotsapxep)
        {
            return DAO.DauSach_DAO.TimKiemSachVaPhanTrang(khoa, sosachtrongmottrang, tranghientai, cotsapxep);
        }
        public static DauSach_DTO LayThongTinChiTietCuaDauSachBoiMa(string madausach)
        {
            return DAO.DauSach_DAO.LayThongTinChiTietCuaDauSachBoiMa(madausach);
        }
    }
}