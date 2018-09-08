using _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.DTO;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using Web2_Chuong1_Phan1_Demo8.Models.DAO;

namespace _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.DAO
{
    public class ChiTietDonMuonSach_DAO
    {
        public static void ThemMotChiTietDonDatSach(ChiTietDonMuonSach_DTO chitietdonmuonsach)
        {
            List<SqlParameter> paras = new List<SqlParameter>();
            paras.Add(new SqlParameter("@madonmuonsach", chitietdonmuonsach.Madonmuonsach));
            paras.Add(new SqlParameter("@madausach", chitietdonmuonsach.Madausach));
            paras.Add(new SqlParameter("@soluong", chitietdonmuonsach.Soluong));
            SQLDataAccess.ThucThiSPKhongTraVeKetQua("sp_ThemMotChiTietDonDatSach", paras);
        }
    }
}