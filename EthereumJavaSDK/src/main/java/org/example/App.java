package org.example;

import org.web3j.protocol.Web3j;
import org.web3j.protocol.http.HttpService;

import java.io.IOException;

public class App
{
    public static void main( String[] args ) throws IOException {
        Web3j web3 = Web3j.build(new HttpService("http://127.0.0.1:8545"));
        String clientVersion = web3.web3ClientVersion().send().getWeb3ClientVersion();
        System.out.println("Connected to Ethereum client version: " + clientVersion);
    }
}
