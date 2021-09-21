using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Chapter05
{
    class LottoN
    {
        private int num;
        private double numOfPercent;

        public LottoN(int num, double numOfPercent)
        {
            this.num = num;
            this.numOfPercent = numOfPercent;
        }

        public int Num { get => num; set => num = value; }
        public double NumOfPercent { get => numOfPercent; set => numOfPercent = value; }
    }
}
