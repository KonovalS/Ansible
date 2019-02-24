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
	:ip_public => "10.10.1.31",
	:ip_privat => "10.10.2.31",
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
	:ip_public => "10.10.1.32",
	:ip_privat => "10.10.2.32",
#},
#{
#	:namebox => "centos6",
#	:box => "centos/6",
#	:hostname => "webserver",
#	:hdd_name => :namebox,
#	:hdd_size => "10000",
#	:cpus => "2",
#	:cpuc => "70",
#	:ram => "1024",
#	:ip_public => "10.10.1.33",
#	:ip_privat => "10.10.2.33",
}
]


# Main config

Vagrant.configure(2) do |main|
	main.ssh.insert_key = false
	templs.each do |templ|
		main.vm.define templ[:namebox] do |vu|
			vu.vm.box = templ[:box]
			vu.vm.hostname = "#{templ[:hostname]}-#{templ[:namebox]}"
#			vu.vm.network :public_network, ip: templ[:ip_public]
			vu.vm.network :private_network, ip: templ[:ip_privat]
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
