using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.DTO
{
    public class DonDatSach_DTO
    {
        private string madonmuonsach;
        private string manguoidung;
        private DateTime ngaydat;
        private DateTime ngaymuon;
        private DateTime ngayhentra;
        private DateTime ngaytra;
        private string matrangthai;

        public string Madonmuonsach
        {
            get
            {
                return madonmuonsach;
            }

            set
            {
                madonmuonsach = value;
            }
        }

        public string Manguoidung
        {
            get
            {
                return manguoidung;
            }

            set
            {
                manguoidung = value;
            }
        }

        public DateTime Ngaydat
        {
            get
            {
                return ngaydat;
            }

            set
            {
                ngaydat = value;
            }
        }

        public DateTime Ngaymuon
        {
            get
            {
                return ngaymuon;
            }

            set
            {
                ngaymuon = value;
            }
        }

        public DateTime Ngayhentra
        {
            get
            {
                return ngayhentra;
            }

            set
            {
                ngayhentra = value;
            }
        }

        public DateTime Ngaytra
        {
            get
            {
                return ngaytra;
            }

            set
            {
                ngaytra = value;
            }
        }

        public string Matrangthai
        {
            get
            {
                return matrangthai;
            }

            set
            {
                matrangthai = value;
            }
        }

        public DonDatSach_DTO()
        {
            madonmuonsach = "";
            manguoidung = "";
            ngaydat = new DateTime(1, 1, 1);
            ngaymuon = new DateTime(1, 1, 1);
            ngayhentra = new DateTime(1, 1, 1);
            ngaytra = new DateTime(1, 1, 1);
            matrangthai = "";
    }
    }
}