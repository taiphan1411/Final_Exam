using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using Web2_Chuong1_Phan1_Demo8.Models.DAO;

namespace _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.DAO
{
    public class ThamSo_DAO
    {
        public static int SoLuongSachToiDaCoTheMuon()
        {
            int soluongtoida = 0;
            DataTable ketqua = SQLDataAccess.ThucThiSPTraVeKetQua("sp_SoLuongSachToiDaCoTheMuon");
            soluongtoida = int.Parse(ketqua.Rows[0][0].ToString());
            return soluongtoida;
        }
    }
}