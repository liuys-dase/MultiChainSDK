package org.example;

import java.util.Objects;
import org.fisco.bcos.sdk.v3.BcosSDK;
import org.fisco.bcos.sdk.v3.client.Client;
import org.fisco.bcos.sdk.v3.client.protocol.response.BlockNumber;
import org.fisco.bcos.sdk.v3.crypto.keypair.CryptoKeyPair;
import org.fisco.bcos.sdk.v3.model.TransactionReceipt;
import org.fisco.bcos.sdk.v3.transaction.model.exception.ContractException;


/**
 * Hello world!
 *
 */
public class App 
{
    // 获取配置文件路径
    public final String configFile = Objects.requireNonNull(App.class.getClassLoader().getResource("config-example.toml")).getPath();
    public void testClient() throws ContractException {
        // 初始化BcosSDK
        BcosSDK sdk =  BcosSDK.build(configFile);
        // 为群组group初始化client
        Client client = sdk.getClient("group0");

        // 获取群组1的块高
        BlockNumber blockNumber = client.getBlockNumber();

        // 部署HelloWorld合约
        CryptoKeyPair cryptoKeyPair = client.getCryptoSuite().getCryptoKeyPair();
        HelloWorld helloWorld = HelloWorld.deploy(client, cryptoKeyPair);

        // 调用HelloWorld合约的get接口
        String getValue = helloWorld.get();
        System.out.println("before set: " + getValue);

        // 调用HelloWorld合约的set接口
        TransactionReceipt receipt = helloWorld.set("Hello, fisco");

        // 调用HelloWorld合约的get接口
        getValue = helloWorld.get();
        System.out.println("after set: " + getValue);
    }

    public static void main(String[] args) throws ContractException {
        App app = new App();
        app.testClient();
    }
}
