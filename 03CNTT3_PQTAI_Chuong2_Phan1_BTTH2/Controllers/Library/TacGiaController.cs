using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Controllers.Library
{
    public class TacGiaController : Controller
    {
        // GET: TacGia
        public ActionResult Xem()
        {
            return View("~/Views/Library/TacGia/Xem.cshtml");
        }
    }
}