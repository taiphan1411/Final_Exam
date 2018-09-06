using _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.BUS;
using _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Controllers.Library
{
    public class KhoSachController : Controller
    {
        // GET: KhoSach
        public ActionResult DuyetKhoSach(string sapxep, string trang)
        {
            int soluongsach = DauSach_BUS.SoLuongSachCoTrongHeThong();
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

            int sotrang = (int) Math.Ceiling((double)soluongsach / (double)sosachtrongmottrang);

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
                dausachs = DauSach_BUS.DuyetKhoSachPhanTrang(sosachtrongmottrang, tranghientai, cotsapxep);
            }

            List<DauSach_DTO> sachs = DauSach_BUS.Top10DauSachXemNhieuNhat();


            ViewBag.soluongsach = soluongsach;
            ViewBag.dausachs = dausachs;
            ViewBag.sotrang = sotrang;
            ViewBag.tranghientai = tranghientai;
            ViewBag.cotsapxep = cotsapxep;
            ViewBag.sachs = sachs;
            return View("~/Views/Library/KhoSach/DuyetKhoSach.cshtml");
        }
        public ActionResult DuyetChuDe(string sapxep, string trang, string ma)
        {
            string machude = "1";
            if (ma != null && ma != "")
            {
                machude = ma;
            }
            int soluongsach = DauSach_BUS.SoLuongSachCoTrongHeThongCuaMotChuDe(machude);
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
                dausachs = DauSach_BUS.DuyetKhoSachTheoChuDePhanTrang(machude, sosachtrongmottrang, tranghientai, cotsapxep);
            }
            List<DauSach_DTO> sachs = DauSach_BUS.Top10DauSachXemNhieuNhatTheoMaChuDe(machude);
            ChuDe_DTO chude = ChuDe_BUS.LayThongTinChiTietChuDeBoiMa(machude);
            ViewBag.soluongsach = soluongsach;
            ViewBag.dausachs = dausachs;
            ViewBag.sotrang = sotrang;
            ViewBag.tranghientai = tranghientai;
            ViewBag.cotsapxep = cotsapxep;
            ViewBag.sachs = sachs;
            ViewBag.machude = machude;
            ViewBag.chude = chude;
            return View("~/Views/Library/KhoSach/DuyetChuDe.cshtml");
        }
    }
}