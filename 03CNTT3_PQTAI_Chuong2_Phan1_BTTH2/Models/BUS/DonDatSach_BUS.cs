using _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.BUS
{
    public class DonDatSach_BUS
    {
        public static bool ThucHienMuonCacCuonSachTrongGioHang(List<Item_DTO> items, string manguoidung)
        {
            int soluongtoidaquydinh = DAO.ThamSo_DAO.SoLuongSachToiDaCoTheMuon();
            int tong = 0;
            foreach (Item_DTO item in items)
            {
                tong = tong + item.Soluong;
            }
            if(tong <= soluongtoidaquydinh && tong > 0)
            {
                DonDatSach_DTO dondatsach = new DonDatSach_DTO();
                dondatsach.Manguoidung = manguoidung;
                dondatsach.Ngaydat = DateTime.Now;
                string madonmuonsach = DAO.DonDatSach_DTO.ThemMotDonDatSach(dondatsach);
                foreach (Item_DTO item in items)
                {
                    ChiTietDonMuonSach_DTO chitietdonmuonsach = new ChiTietDonMuonSach_DTO();
                    chitietdonmuonsach.Machitietdonmuonsach = madonmuonsach;
                    chitietdonmuonsach.Madausach = item.Madausach;
                    chitietdonmuonsach.Soluong = item.Soluong;
                    DAO.ChiTietDonMuonSach_DAO.ThemMotChiTietDonDatSach(chitietdonmuonsach);
                }
                return true;
            }
            else
            {
                return false;
            }
        }
    }
}