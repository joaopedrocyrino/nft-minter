const deployContract = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments;
    const { deployer } = await getNamedAccounts();

    log('\n-------------------------------------------\n');

    const CyrinoNFT = await deploy('CyrinoNFT', { from: deployer, log: true });

    log(`\nYou have deployed an NFT contract to ${CyrinoNFT.address}\n`);

};

module.exports = deployContract

module.exports.tags = ['all', 'svg']