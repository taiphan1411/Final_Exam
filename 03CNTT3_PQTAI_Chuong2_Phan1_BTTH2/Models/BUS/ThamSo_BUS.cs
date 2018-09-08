using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.BUS
{
    public class ThamSo_BUS
    {
        public static int SoLuongSachToiDaCoTheMuon()
        {
            return DAO.ThamSo_DAO.SoLuongSachToiDaCoTheMuon();
        }
    }
}