import { Skeleton, Card, CardHeader, CardBody, CardFooter, Image, Button, Input, Progress } from "@nextui-org/react";
import { useState, memo } from 'react';
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend,
} from 'chart.js';
import { Bar } from 'react-chartjs-2';

ChartJS.register(
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend
);

export default function Home() {
  const [data, setData] = useState([{ name: 'SPIRAL+' }, { name: '逆時針螺旋' }, { name: 'k-means(SPIRAL+)' }, { name: 'k-means(逆時針螺旋)' }, { name: '隨機' }, { name: 'vonoroi' }]);
  const [isLoaded, setIsLoaded] = useState(false);
  const [progress, setProgress] = useState(0);

  const [ue_size, setUeSize] = useState(600);
  const [rangeOfPosition, setRangeOfPosition] = useState(400);
  const [r_UAVBS, setRUAVBS] = useState(60);
  const [minDataTransferRateOfUEAcceptable, setMinDataTransferRateOfUEAcceptable] = useState(6);
  const [maxDataTransferRateOfUAVBS, setMaxDataTransferRateOfUAVBS] = useState(150);
  const BarChart = memo(({ data, title, attr, max, cb = v => v }) => {
    var yAxes = { min: 0 }
    if (max) yAxes.max = max;
    return (
      <Bar
        options={{
          scales: {
            y: yAxes
          },
          responsive: true,
          plugins: {
            legend: {
              display: false,
            },
            title: {
              display: true,
              text: title,
            },
          },
        }}
        data={{
          labels: data.map(d => d.name),
          datasets: [
            {
              data: data.map(d => (d[attr] ? cb(d[attr]) : 0)),
              backgroundColor: '#0084ff99',
            }
          ],
        }}
      />
    )
  });

  function status_init() {
    setIsLoaded(false);
    setProgress(0);
  }

  function loadData(index, d) {
    setData(prevData => {
      let tempData = prevData;
      tempData[index] = { name: tempData[index].name, ...d };
      return tempData;
    });
  }

  async function executeSimulation() {
    setData([{ name: 'SPIRAL+' }, { name: '逆時針螺旋' }, { name: 'k-means(SPIRAL+)' }, { name: 'k-means(逆時針螺旋)' }, { name: '隨機' }, { name: 'vonoroi' }]);
    setIsLoaded(true);
    const steps = 8;
    let response, index;
    const time = new Date().getTime();

    function getOption(op) {
      return {
        headers: {
          'Content-Type': 'application/json'
        },
        method: 'POST',
        body: JSON.stringify({
          ...op,
          index: index + 1,
          ue_size: parseInt(ue_size),
          rangeOfPosition: parseInt(rangeOfPosition),
          r_UAVBS: parseInt(r_UAVBS),
          minDataTransferRateOfUEAcceptable: parseInt(minDataTransferRateOfUEAcceptable),
          maxDataTransferRateOfUAVBS: parseInt(maxDataTransferRateOfUAVBS)
        })
      }
    }

    response = await fetch('http://127.0.0.1:8088/init', getOption({})).then(response => response.json());
    if (!response.status) return status_init();
    setProgress(1 / steps * 100);

    index = 0;
    response = await fetch('http://127.0.0.1:8088/ourAlgorithm', getOption({})).then(response => response.json());
    if (!response.status) return status_init();
    loadData(index, {
      image: `http://127.0.0.1:8088/static/ourAlgorithm.jpg?t=${time}`,
      ...response.data
    });
    setProgress(2 / steps * 100);
    let k1 = response.data.k;

    index = 1;
    response = await fetch('http://127.0.0.1:8088/spiralMBSPlacementAlgorithm', getOption({})).then(response => response.json());
    if (!response.status) return status_init();
    loadData(index, {
      image: `http://127.0.0.1:8088/static/spiralMBSPlacementAlgorithm.jpg?t=${time}`,
      ...response.data
    });
    setProgress(3 / steps * 100);
    let k2 = response.data.k;

    index = 2;
    response = await fetch('http://127.0.0.1:8088/kmeans', getOption({ k: k1 })).then(response => response.json());
    if (!response.status) return status_init();
    loadData(index, {
      image: `http://127.0.0.1:8088/static/kmeans_${index + 1}.jpg?t=${time}`,
      ...response.data
    });
    setProgress(4 / steps * 100);
    console.log(index, data);

    index = 3;
    response = await fetch('http://127.0.0.1:8088/kmeans', getOption({ k: k2 })).then(response => response.json());
    if (!response.status) return status_init();
    loadData(index, {
      image: `http://127.0.0.1:8088/static/kmeans_${index + 1}.jpg?t=${time}`,
      ...response.data
    });
    setProgress(5 / steps * 100);
    console.log(index, data);

    index = 4;
    response = await fetch('http://127.0.0.1:8088/random', getOption({})).then(response => response.json());
    if (!response.status) return status_init();
    loadData(index, {
      image: `http://127.0.0.1:8088/static/randomAlgorithm.jpg?t=${time}`,
      ...response.data
    });
    setProgress(6 / steps * 100);
    console.log(index, data);

    index = 5;
    response = await fetch('http://127.0.0.1:8088/voronoi', getOption({})).then(response => response.json());
    if (!response.status) return status_init();
    loadData(index, {
      image: `http://127.0.0.1:8088/static/voronoi.jpg?t=${time}`,
      ...response.data
    });
    setProgress(7 / steps * 100);
    console.log(index, data);

    setTimeout(status_init, 1000);
  }

  return (
    <main className={`flex h-screen`}>
      <Card className='min-w-[15%] h-screen' radius='none'>
        <CardHeader>
          <h2 className="font-bold text-xl">參數</h2>
        </CardHeader>
        <CardBody className='flex flex-col gap-6'>
          <Input
            type="number"
            label="生成地面裝置數量"
            labelPlacement="outside"
            placeholder=""
            value={ue_size}
            onInput={e => setUeSize(e.target.value)}
          />
          <Input
            type="number"
            label="座標範圍"
            placeholder=""
            labelPlacement="outside"
            value={rangeOfPosition}
            onInput={e => setRangeOfPosition(e.target.value)}
            startContent={
              <div className="pointer-events-none flex items-center">
                <span className="text-default-400 text-small">0~</span>
              </div>
            }
          />
          <Input
            type="number"
            label="無人機服務半徑"
            placeholder=""
            labelPlacement="outside"
            value={r_UAVBS}
            onInput={e => setRUAVBS(e.target.value)}
          />
          <Input
            type="number"
            label="使用者滿意最低速率"
            placeholder=""
            labelPlacement="outside"
            value={minDataTransferRateOfUEAcceptable}
            onInput={e => setMinDataTransferRateOfUEAcceptable(e.target.value)}
            endContent={
              <div className="pointer-events-none flex items-center">
                <span className="text-default-400 text-small">Mbps</span>
              </div>
            }
          />
          <Input
            type="number"
            label="無人機回程速率上限"
            placeholder=""
            labelPlacement="outside"
            value={maxDataTransferRateOfUAVBS}
            onInput={e => setMaxDataTransferRateOfUAVBS(e.target.value)}
            endContent={
              <div className="pointer-events-none flex items-center">
                <span className="text-default-400 text-small">Mbps</span>
              </div>
            }
          />
        </CardBody>
        <CardFooter>
          <Button
            isLoading={isLoaded}
            color='primary'
            className="w-full"
            onClick={executeSimulation}
          >執行模擬</Button>
        </CardFooter>
      </Card>

      <div className='grow overflow-y-scroll h-screen relative'>
        <Progress color="success" value={progress} className='sticky top-0 left-0 z-10' />
        <div className="px-10 w-full">
          <div className='flex justify-between flex-wrap items-start mt-3 z-0 px-5'>
            <h2 className='w-[30%] font-bold text-xl m-2'>部署模擬圖</h2>
            <h2 className='w-[30%] font-bold text-xl m-2'></h2>
            <h2 className='w-[30%] font-bold text-xl m-2'></h2>
            {
              data.map((d, index) => {
                return (
                  <Card className='w-[30%] m-2 aspect-square relative' key={'res_' + index}>
                    <CardHeader className="absolute z-10 top-1 flex-col !items-start">
                      <p className="font-bold">{d.name}</p>
                      {d.satisfiedRateData && <p>滿意度：{Math.round(d.satisfiedRateData * 100)}% 公平性：{d.fairnessData.toFixed(2)}</p>}
                    </CardHeader>
                    {
                      d.image ?
                        <Image
                          removeWrapper
                          alt="Card background"
                          className="z-0 w-full h-full object-cover"
                          src={d.image}
                        />
                        :
                        <Skeleton className="w-full h-full" />
                    }
                  </Card>
                )
              })
            }
          </div>
          <div className='flex justify-center flex-wrap items-start mt-3 px-5 z-0'>
            <h2 className='w-[48%] font-bold text-xl m-2'>圖表</h2>
            <h2 className='w-[48%] font-bold text-xl m-2'></h2>
            <Card className='w-[48%] m-2 relative' >
              <BarChart data={data} title='滿意度(%)' attr='satisfiedRateData' cb={v => v * 100} max={100} />
            </Card>
            <Card className='w-[48%] m-2 relative' >
              <BarChart data={data} title='公平性' attr='fairnessData' max={1} />
            </Card>
            <Card className='w-[48%] m-2 relative' >
              <BarChart data={data} title='能源效率' attr='energyEfficiency' />
            </Card>
          </div>
        </div>
      </div>
    </main>
  )
}
