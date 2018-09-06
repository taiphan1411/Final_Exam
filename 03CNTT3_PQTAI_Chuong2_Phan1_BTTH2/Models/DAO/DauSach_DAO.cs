using _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using Web2_Chuong1_Phan1_Demo8.Models.DAO;

namespace _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.DAO
{
    public class DauSach_DAO
    {
        public static int SoLuongSachCoTrongHeThong()
        {
            int soluong = 0;
            DataTable ketqua = SQLDataAccess.ThucThiSPTraVeKetQua("sp_SoLuongSachCoTrongHeThong");
            soluong = (int)ketqua.Rows[0][0];
            return soluong;
        }
        public static List<DauSachFull_DTO> DuyetKhoSachPhanTrang(int sosachtrongmottrang, int tranghientai, string cotsapxep)
        {
            List<DauSachFull_DTO> dausachs = new List<DauSachFull_DTO>();
            List<SqlParameter> paras = new List<SqlParameter>();
            paras.Add(new SqlParameter("@sosachtrongmottrang", sosachtrongmottrang));
            paras.Add(new SqlParameter("@tranghientai", tranghientai));
            paras.Add(new SqlParameter("@cotsapxep", cotsapxep));
            DataTable ketqua = SQLDataAccess.ThucThiSPTraVeKetQua("sp_DuyetKhoSachPhanTrang", paras);
            if (ketqua.Rows.Count > 0)
            {
                foreach(DataRow dong in ketqua.Rows)
                {
                    DauSachFull_DTO dausach = new DauSachFull_DTO();
                    dausach.Bia = dong["bia"].ToString();
                    //if (dong["filesach"] != null)
                    //{
                    //    dausach.Filesach = dong["filesach"].ToString();
                    //}
                    //dausach.Luotxem = (int)dong["luotxem"];
                    //dausach.Machude = dong["machude"].ToString();
                    dausach.Madausach = dong["madausach"].ToString();
                    //dausach.Manhaxuatban = dong["manhaxuatban"].ToString();
                    //dausach.Matacgia = dong["matacgia"].ToString();
                    //dausach.Ngaydang = (DateTime)dong["ngaydang"];
                    //if (dong["soluong"] != null)
                    //{
                    //    dausach.Soluong = (int)dong["soluong"];
                    //}
                    dausach.Tensach = dong["tensach"].ToString();
                    //if (dong["tomtat"] != null)
                    //{
                    //    dausach.Tomtat = dong["tomtat"].ToString();
                    //}
                    //dausach.Tenchude = dong["tenchude"].ToString();
                    //dausach.Tennhaxuatban = dong["tennhaxuatban"].ToString();
                    dausach.Tentacgia = dong["tentacgia"].ToString();
                    dausachs.Add(dausach); 
                }
            }
            return dausachs;
        }
        public static List<DauSach_DTO> Top10DauSachXemNhieuNhat()
        {
            List<DauSach_DTO> dausachs = new List<DauSach_DTO>();
            DataTable ketqua = SQLDataAccess.ThucThiSPTraVeKetQua("sp_Top10DauSachXemNhieuNhat");
            if (ketqua.Rows.Count > 0)
            {
                foreach (DataRow dong in ketqua.Rows)
                {
                    DauSach_DTO dausach = new DauSach_DTO();
                    dausach.Bia = dong["bia"].ToString();
                    dausach.Madausach = dong["madausach"].ToString();
                    dausach.Tensach = dong["tensach"].ToString();
                    dausachs.Add(dausach);
                }
            }
            return dausachs;
        }
        public static int SoLuongSachCoTrongHeThongCuaMotChuDe(string machude)
        {
            int soluong = 0;
            List<SqlParameter> paras = new List<SqlParameter>();
            paras.Add(new SqlParameter("@machude", machude));
            DataTable ketqua = SQLDataAccess.ThucThiSPTraVeKetQua("sp_SoLuongSachCoTrongHeThongCuaMotChuDe",paras);
            soluong = (int)ketqua.Rows[0][0];
            return soluong;
        }
        public static List<DauSachFull_DTO> DuyetKhoSachTheoChuDePhanTrang(string machude, int sosachtrongmottrang, int tranghientai, string cotsapxep)
        {
            List<DauSachFull_DTO> dausachs = new List<DauSachFull_DTO>();
            List<SqlParameter> paras = new List<SqlParameter>();
            paras.Add(new SqlParameter("@machude", machude));
            paras.Add(new SqlParameter("@sosachtrongmottrang", sosachtrongmottrang));
            paras.Add(new SqlParameter("@tranghientai", tranghientai));
            paras.Add(new SqlParameter("@cotsapxep", cotsapxep));
            DataTable ketqua = SQLDataAccess.ThucThiSPTraVeKetQua("sp_DuyetKhoSachTheoChuDePhanTrang", paras);
            if (ketqua.Rows.Count > 0)
            {
                foreach (DataRow dong in ketqua.Rows)
                {
                    DauSachFull_DTO dausach = new DauSachFull_DTO();
                    dausach.Bia = dong["bia"].ToString();
                    dausach.Madausach = dong["madausach"].ToString();
                    dausach.Tensach = dong["tensach"].ToString();
                    dausach.Tentacgia = dong["tentacgia"].ToString();
                    dausachs.Add(dausach);
                }
            }
            return dausachs;
        }
        public static List<DauSach_DTO> Top10DauSachXemNhieuNhatTheoMaChuDe(string machude)
        {
            List<DauSach_DTO> dausachs = new List<DauSach_DTO>();
            List<SqlParameter> paras = new List<SqlParameter>();
            paras.Add(new SqlParameter("@machude", machude));
            DataTable ketqua = SQLDataAccess.ThucThiSPTraVeKetQua("sp_Top10DauSachXemNhieuNhatTheoMaChuDe",paras);
            if (ketqua.Rows.Count > 0)
            {
                foreach (DataRow dong in ketqua.Rows)
                {
                    DauSach_DTO dausach = new DauSach_DTO();
                    dausach.Bia = dong["bia"].ToString();
                    dausach.Madausach = dong["madausach"].ToString();
                    dausach.Tensach = dong["tensach"].ToString();
                    dausachs.Add(dausach);
                }
            }
            return dausachs;
        }
        public static int SoLuongSachTimKiemDuoc(string khoa)
        {
            int soluong = 0;
            List<SqlParameter> paras = new List<SqlParameter>();
            paras.Add(new SqlParameter("@khoa", khoa));
            DataTable ketqua = SQLDataAccess.ThucThiSPTraVeKetQua("sp_SoLuongSachTimKiemDuoc",paras);
            soluong = (int)ketqua.Rows[0][0];
            return soluong;
        }
        public static List<DauSachFull_DTO> TimKiemSachVaPhanTrang(string khoa, int sosachtrongmottrang, int tranghientai, string cotsapxep)
        {
            List<DauSachFull_DTO> dausachs = new List<DauSachFull_DTO>();
            List<SqlParameter> paras = new List<SqlParameter>();
            paras.Add(new SqlParameter("@khoa", khoa));
            paras.Add(new SqlParameter("@sosachtrongmottrang", sosachtrongmottrang));
            paras.Add(new SqlParameter("@tranghientai", tranghientai));
            paras.Add(new SqlParameter("@cotsapxep", cotsapxep));
            DataTable ketqua = SQLDataAccess.ThucThiSPTraVeKetQua("sp_TimKiemSachVaPhanTrang", paras);
            if (ketqua.Rows.Count > 0)
            {
                foreach (DataRow dong in ketqua.Rows)
                {
                    DauSachFull_DTO dausach = new DauSachFull_DTO();
                    dausach.Bia = dong["bia"].ToString();
                    dausach.Madausach = dong["madausach"].ToString();
                    dausach.Tensach = dong["tensach"].ToString();
                    dausach.Tentacgia = dong["tentacgia"].ToString();
                    dausachs.Add(dausach);
                }
            }
            return dausachs;
        }
    }
}