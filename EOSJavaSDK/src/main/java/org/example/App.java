package org.example;

import one.block.eosiojava.error.rpcProvider.GetBlockRpcError;
import one.block.eosiojava.error.rpcProvider.GetInfoRpcError;
import one.block.eosiojava.error.rpcProvider.GetRawAbiRpcError;
import one.block.eosiojava.models.rpcProvider.response.GetInfoResponse;
import one.block.eosiojavarpcprovider.error.EosioJavaRpcProviderInitializerError;
import one.block.eosiojavarpcprovider.implementations.EosioJavaRpcProviderImpl;

public class App
{
    public static void main( String[] args ) throws EosioJavaRpcProviderInitializerError, GetInfoRpcError {
        EosioJavaRpcProviderImpl rpcProvider = new EosioJavaRpcProviderImpl(
                "http://127.0.0.1:8888"
        );
        GetInfoResponse info = rpcProvider.getInfo();
        System.out.println("Chain ID: " + info.getChainId());
    }
}
