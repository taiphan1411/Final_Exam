using _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.BUS;
using _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Controllers.Library
{
    public class TrangChuController : Controller
    {
        public ActionResult Xem()
        {
            List<Sach_DTO> sachs = Sach_BUS.LayDanhSachCacDauSach();
            ViewBag.hanh = sachs;
            return View("~/Views/Library/TrangChu/Xem.cshtml");
        }
    }
}