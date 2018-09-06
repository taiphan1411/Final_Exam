using _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.DAO;
using _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.BUS
{
    public class ChuDe_BUS
    {
        public static List<ChuDe_DTO> LayDanhSachChuDe()
        {
            
            return ChuDe_DAO.LayDanhSachChuDe();
        }
        public static ChuDe_DTO LayThongTinChiTietChuDeBoiMa(string machude)
        {
            return ChuDe_DAO.LayThongTinChiTietChuDeBoiMa(machude);
        }
    }
}