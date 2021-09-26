const main = async () => {
    const [owner, randoPerson] = await hre.ethers.getSigners();
    const waveContractFactory = await hre.ethers.getContractFactory('WavePortal');
    const waveContract = await waveContractFactory.deploy({
        value: hre.ethers.utils.parseEther('0.1'),
      });
    await waveContract.deployed();
    console.log("Contract deployed to:", waveContract.address);
    console.log("Contract deployed by:", owner.address);
  
      /*
    * Get Contract balance
     */
     let contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
     console.log(
        'Contract balance:',
        hre.ethers.utils.formatEther(contractBalance)
      );

  let waveCount;
  waveCount = await waveContract.getTotalWaves();

  let waveTxn = await waveContract.wave('A Message');
  await waveTxn.wait();

  waveCount = await waveContract.getTotalWaves();
                //do a transaction from another wallet
  waveTxn = await waveContract.connect(randoPerson).wave('Another Message New Signer');
  await waveTxn.wait();

  waveCount = await waveContract.getTotalWaves();

  /*
   * Get Contract balance to see what happened!
   */
  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log(
    'Contract balance:',
    hre.ethers.utils.formatEther(contractBalance)
  );

  let allWaves = await waveContract.getAllWaves();
  console.log(allWaves);

};
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMain();