package org.zstack.network.service.lb

import org.zstack.header.errorcode.ErrorCode
import org.zstack.network.service.lb.LoadBalancerListenerInventory

doc {

	title "修改负载均衡监听器证书返回值"

	ref {
		name "error"
		path "org.zstack.network.service.lb.APIChangeLoadBalancerListenerCertificateEvent.error"
		desc "错误码，若不为null，则表示操作失败, 操作成功时该字段为null",false
		type "ErrorCode"
		since "0.6"
		clz ErrorCode.class
	}
	ref {
		name "inventory"
		path "org.zstack.network.service.lb.APIChangeLoadBalancerListenerCertificateEvent.inventory"
		desc "null"
		type "LoadBalancerListenerInventory"
		since "0.6"
		clz LoadBalancerListenerInventory.class
	}
}