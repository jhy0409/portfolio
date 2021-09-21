using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Chapter05.cont
{
    class Handler
    {
        static Random r = new Random();
        public Handler()
        {
            iplyok();

        }

        readonly List<LottoN> lottoNumNIndex = new List<LottoN>();
        readonly double[] joncheHwaklyul = {0.93, 0.87, 0.87, 0.93, 0.84, 0.84, 0.84, 0.84, 0.7,  0.9, 
                                            0.86, 0.92, 0.93, 0.87, 0.84, 0.84, 0.93, 0.89, 0.85, 0.9, 
                                            0.85, 0.71, 0.75, 0.86, 0.8,  0.88, 0.95, 0.77, 0.74, 0.83, 
                                            0.87, 0.77, 0.91, 0.94, 0.82, 0.84, 0.86, 0.89, 0.91, 0.89, 
                                            0.76, 0.83, 1,    0.83, 0.85};
        int[] goodLuck = new int[7];


        public int[] GoodLuck { get => goodLuck; set => goodLuck = value; }

        public void makeLotto(int randNum)
        {
            for (int i = 0; i < goodLuck.Length; i++)
            {
                goodLuck[i] = r.Next(1, 46);
                //Console.Write($"{goodLuck[i]}, "); // 생성 값

                if (i < (goodLuck.Length - randNum) && hwaklyul(goodLuck[i]) < 0.9) // (7 - randNum)번째 숫자까지는 번호당 확률 70%이상
                {
                    i--;
                }
                
                if (i >= (goodLuck.Length - randNum)) // 마지막 번호 randNum개는 랜덤
                {
                    goodLuck[i] = r.Next(1, 46);
                }
                for (int j = 0; j < i; j++)
                {
                    if (goodLuck[i] == goodLuck[j])
                    {
                        i--;
                        Console.WriteLine($"[{j + 1}번째 값 중복발생 : {goodLuck[j]}]");
                    }
                }
            }
            Array.Sort(goodLuck);

            for (int i = 0; i < goodLuck.Length; i++)
            {
                Console.Write($"{goodLuck[i]},\t");
            }
            Console.WriteLine();
        }


        public void iplyok()
        {
            // 1~957회차 전체번호(1~45)별 확률 (로또 홈페이지 자료 참고)
            for (int i = 0; i < 45; i++)
            {
                lottoNumNIndex.Add(new LottoN((i + 1), joncheHwaklyul[i]));
            }
        }

        public double hwaklyul(int lotto)
        {
            int index = 0;
            for (int i = 0; i < lottoNumNIndex.Count; i++)
            {
                if (lottoNumNIndex[i].Num == lotto)
                {
                    index = i;
                }
            }
            return lottoNumNIndex[index].NumOfPercent;
        }
    }
}
