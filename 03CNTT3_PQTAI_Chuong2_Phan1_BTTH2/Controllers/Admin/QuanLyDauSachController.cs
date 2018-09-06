using _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.BUS;
using _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Controllers.Admin
{
    public class QuanLyDauSachController : Controller
    {
        // GET: QuanLyDauSach
        public ActionResult Xem()
        {
            if (Session["phanquyen"].ToString() == "u" || Session["phanquyen"].ToString() == "me")
            {
                return Redirect("/TrangChu/Xem");
            }
            List<Sach_DTO> sachs = Sach_BUS.LayDanhSachCacDauSach();
            ViewBag.sachs = sachs;

            return View("~/Views/Admin/QuanLyDauSach/Xem.cshtml");
        }
    }
}