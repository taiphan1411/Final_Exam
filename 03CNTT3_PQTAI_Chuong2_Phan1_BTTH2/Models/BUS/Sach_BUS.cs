using _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.DAO;
using _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.BUS
{
    public class Sach_BUS
    {
        public static List<Sach_DTO> LayDanhSachCacDauSach()
        {
            return Sach_DAO.LayDanhSachCacDauSach();
        }
    }
}