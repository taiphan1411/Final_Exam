using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Controllers.Admin
{
    public class QuanLyTacGiaController : Controller
    {
        // GET: QuanLyTacGia
        public ActionResult Xem()
        {
            if (Session["phanquyen"].ToString() == "u" || Session["phanquyen"].ToString() == "me")
            {
                return Redirect("/TrangChu/Xem");
            }
            return View("~/Views/Admin/QuanLyTacGia/Xem.cshtml");
        }
    }
}