## Fisco-Bcos Java SDK 使用

### 第一步. 引入 Java SDK

添加 maven 依赖

```xml
<dependency>
    <groupId>org.fisco-bcos.java-sdk</groupId>
    <artifactId>fisco-bcos-java-sdk</artifactId>
    <version>3.6.0</version>
</dependency>
```



### 第二步. 配置 SDK 证书

参考 [Java SDK 证书配置](https://fisco-bcos-doc.readthedocs.io/zh-cn/latest/docs/sdk/java_sdk/config.html#id5)

1. 在 `resouces` 目录下创建一个 `conf` 目录，从节点 `nodes/${ip}/sdk/` 目录下的证书拷贝到`conf` 目录

```shell
cp -r path/to/nodes/127.0.0.1/sdk/* path/to/conf/
```

2. 将配置文件 `config-example.toml`, 存放在应用的主目录下（[配置文件](https://github.com/FISCO-BCOS/java-sdk/blob/master/src/test/resources/config-example.toml)）

3. 修改 `config-example.toml` 中节点的 IP 和端口，与您要连接的节点所匹配

```toml
[network]
peers=["127.0.0.1:30300"]
```

4. 在您的应用中使用该配置文件初始化 Java SDK，您就可以开发区块链应用了

```java
String configFile = "config-example.toml";
BcosSDK sdk =  BcosSDK.build(configFile);
```

### 第三步. 准备智能合约

控制台 `console` 和 `java-sdk-demo` 均提供了工具，可以将 `solidity` 合约生成出调用该合约 `java` 工具类。本例中使用 `console` 作为例子

```shell
mkdir -p ~/fisco && cd ~/fisco

# 获取控制台
curl -#LO https://osp-1257653870.cos.ap-guangzhou.myqcloud.com/FISCO-BCOS/console/releases/v3.6.0/download_console.sh

bash download_console.sh
cd ~/fisco/console
```

然后，将您要用到的 Solidity 智能合约放入 `~/fisco/console/contracts/solidity` 的目录，本次我们用 console 中的 `HelloWorld.sol` 作为例子。

```shell
# 当前目录~/fisco/console
ls contracts/solidity 
```

得到返回

```shell
Asset.sol  Cast.sol  CastTest.sol  Crypto.sol  DelegateCallTest.sol  EntryWrapper.sol  EventSubDemo.sol  HelloWorld.sol  KVTableTest.sol  ShaTest.sol  Table.sol  TableTest.sol  TableTestV320.sol  TableV320.sol
```

接着，生成调用该智能合约的 java 类

```shell
# 使用sol2java.sh将contracts/solidity下的所有合约编译产生bin,abi,java工具类。
# 当前目录~/fisco/console
bash contract2java.sh solidity -p org.com.fisco -s ./contracts/solidity/HelloWorld.sol
# 以上命令中参数“org.com.fisco”是指定产生的java类所属的包名。
# 通过命令./sol2java.sh -h可查看该脚本使用方法
```

查看编译结果

```shell
ls contracts/sdk/java/org/com/fisco 
# 得到返回
# HelloWorld.java
```



## 第四步. 使用 Java SDK 部署和调用智能合约

以使用 Java SDK 调用群组1的 `getBlockNumber` 接口获取群组1最新块高，并向群组1部署和调用 `HelloWorld` 合约为例，对应的示例代码如下：

```java
public class BcosSDKTest
{
    // 获取配置文件路径
    public final String configFile = BcosSDKTest.class.getClassLoader().getResource("config-example.toml").getPath();
     public void testClient() throws ConfigException {
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
        
        // 调用HelloWorld合约的set接口
        TransactionReceipt receipt = helloWorld.set("Hello, fisco");
     }
}
```



