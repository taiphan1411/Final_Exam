using _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.DTO;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using Web2_Chuong1_Phan1_Demo8.Models.DAO;

namespace _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.DAO
{
    public class DonDatSach_DTO
    {
        public static string ThemMotDonDatSach(DTO.DonDatSach_DTO dondatsach)
        {
            List<SqlParameter> paras = new List<SqlParameter>();
            paras.Add(new SqlParameter("@manguoidung", dondatsach.Manguoidung));
            paras.Add(new SqlParameter("@ngaydat", dondatsach.Ngaydat));
            SqlParameter madondatsach = new SqlParameter("@madonmuonsach", "");
            madondatsach.SqlDbType = System.Data.SqlDbType.NVarChar;
            madondatsach.Size = 100;
            madondatsach.Direction = System.Data.ParameterDirection.InputOutput;
            paras.Add(madondatsach);
            SQLDataAccess.ThucThiSPKhongTraVeKetQua("sp_ThemMotDonDatSach", paras);
            return madondatsach.SqlValue.ToString();
        }
    }
}