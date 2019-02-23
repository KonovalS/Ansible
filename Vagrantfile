# -*-mode: ruby -*-

# Set VM config

templs = [

	{
	:namebox => "debian9",
	:box => "4linux/debian9",
	:hostname => "webserver",
	:hdd_name => :namebox,
	:hdd_size => "10000",
	:cpus => "2",
	:cpuc => "70",
	:ram => "1024",
	:ip1 => "10.10.1.31",
	:ip2 => "10.10.2.32",
},
{
	:namebox => "centos7",
	:box => "centos/7",
	:hostname => "webserver",
	:hdd_name => :namebox,
	:hdd_size => "10000",
	:cpus => "2",
	:cpuc => "70",
	:ram => "1024",
	:ip1 => "10.10.1.33",
	:ip2 => "10.10.2.34",
},
{
	:namebox => "centos6",
	:box => "centos/6",
	:hostname => "webserver",
	:hdd_name => :namebox,
	:hdd_size => "10000",
	:cpus => "2",
	:cpuc => "70",
	:ram => "1024",
	:ip1 => "10.10.1.35",
	:ip2 => "10.10.2.36",
}
]


# Main config

Vagrant.configure(2) do |main|
	main.ssh.insert_key = false
	templs.each do |templ|
		main.vm.define templ[:namebox] do |vu|
			vu.vm.box = templ[:box]
			vu.vm.hostname = "#{templ[:hostname]}-#{templ[:namebox]}"
			vu.vm.network :public_network, ip: templ[:ip1]
			vu.vm.network :private_network, ip: templ[:ip2]
			vu.vm.provider "virtualbox" do |vb|
				vb.customize ["modifyvm", :id, "--cpuexecutioncap", templ[:cpuc]]
				vb.customize ["modifyvm", :id, "--cpus", templ[:cpus]]
				vb.customize ["modifyvm", :id, "--memory", templ[:ram]]
			vu.vm.provision "ansible" do |ansible|
				ansible.verbose = "v"
				ansible.playbook =  "playbook.yml"
			end
			end
		end
	end
end
