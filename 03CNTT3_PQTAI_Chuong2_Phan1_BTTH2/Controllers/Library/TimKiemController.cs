using _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.BUS;
using _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Controllers.Library
{
    public class TimKiemController : Controller
    {
        // GET: TimKiem
        public ActionResult ThucHienTimKiem(string khoa, string sapxep, string trang)
        {
            int soluongsach = DauSach_BUS.SoLuongSachTimKiemDuoc(khoa);
            int sosachtrongmottrang = 30;
            int tranghientai = 1;
            if (trang != null && trang != "")
            {
                tranghientai = int.Parse(trang);
            }

            string cotsapxep = "ngaydang";
            if (sapxep != null && sapxep != "")
            {
                cotsapxep = sapxep;
            }

            int sotrang = (int)Math.Ceiling((double)soluongsach / (double)sosachtrongmottrang);

            if (tranghientai <= 0)
            {
                tranghientai = 1;
            }
            if (tranghientai > sotrang)
            {
                tranghientai = sotrang;
            }

            List<DauSachFull_DTO> dausachs = new List<DauSachFull_DTO>();
            if (sotrang > 0)
            {
                dausachs = DauSach_BUS.TimKiemSachVaPhanTrang(khoa, sosachtrongmottrang, tranghientai, cotsapxep);
            }
            ViewBag.soluongsach = soluongsach;
            ViewBag.dausachs = dausachs;
            ViewBag.sotrang = sotrang;
            ViewBag.tranghientai = tranghientai;
            ViewBag.cotsapxep = cotsapxep;
            ViewBag.khoa = khoa;
            return View("~/Views/Library/TimKiem/ThucHienTimKiem.cshtml");
        }
    }
}