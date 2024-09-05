package org.example;

import cn.hyperchain.sdk.account.Account;
import cn.hyperchain.sdk.account.Algo;
import cn.hyperchain.sdk.common.utils.FileUtil;
import cn.hyperchain.sdk.provider.DefaultHttpProvider;
import cn.hyperchain.sdk.provider.ProviderManager;
import cn.hyperchain.sdk.response.ReceiptResponse;
import cn.hyperchain.sdk.service.AccountService;
import cn.hyperchain.sdk.service.ContractService;
import cn.hyperchain.sdk.service.ServiceManager;
import cn.hyperchain.sdk.transaction.Transaction;

import java.io.InputStream;

// https://github.com/hyperchain/javasdk/blob/master/src/test/java/cn/hyperchain/sdk/HVMTest.java
public class App
{
    //合约jar包路径
    String jarPath = "contractcollection-2.0-SNAPSHOT.jar";
    String defaultURL = "localhost:8081";

    public static void main(String[] args) throws Exception {
        App t = new App();
        t.testSBank();
    }

    public void testSBank() throws Exception {
        InputStream is = FileUtil.readFileAsStream(jarPath);
        DefaultHttpProvider defaultHttpProvider = new DefaultHttpProvider.Builder().setUrl(defaultURL).build();
        ProviderManager providerManager = ProviderManager.createManager(defaultHttpProvider);

        ContractService contractService = ServiceManager.getContractService(providerManager);
        AccountService accountService = ServiceManager.getAccountService(providerManager);
        Account account = accountService.genAccount(Algo.ECRAW);


        //部署合约
        Transaction transaction = new Transaction.HVMBuilder(account.getAddress()).deploy(is).build();
        transaction.sign(account);
        ReceiptResponse receiptResponse = contractService.deploy(transaction).send().polling();
        //获取合约地址
        String contractAddress = receiptResponse.getContractAddress();
        System.out.println("contract address: " + contractAddress);

//        //调用合约
//        Transaction transaction1 = new
//                //创建指定invoke bean的交易
//                Transaction.HVMBuilder(account.getAddress()).invoke(contractAddress, new InvokeBank("AAA", "BBB", 100)).build();
//        transaction1.sign(account);
//        ReceiptResponse receiptResponse1 = contractService.invoke(transaction1).send().polling();
//        //对交易执行结果进行解码
//        String decodeHVM = Decoder.decodeHVM(receiptResponse1.getRet(), String.class);
//        System.out.println("decode: " + decodeHVM);
    }
}
