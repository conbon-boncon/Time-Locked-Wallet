const TimeLockedWallet = artifacts.require('TimeLockedWallet');

contract('TimeLockedWallet', () => {

    it('Should deploy TimeLockedWallet', async () =>{
        const timeLockedWallet = await TimeLockedWallet.deployed();
        assert(timeLockedWallet != '');
        assert(timeLockedWallet != 'OXO');
    });

   it('Should return current balance of contract', async () =>{
        const timeLockedWallet = await TimeLockedWallet.deployed();
        const balance = await timeLockedWallet.getBalance();
        assert(balance == 0);
   });

});