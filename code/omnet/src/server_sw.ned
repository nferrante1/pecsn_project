//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
// 

package pecsn_project;

module Server_sw
{
    parameters:
        int n; //Clients number
        int m; //Multiprogramming grade
        @display("bgb=339,230");
    gates:
        inout io[n];
        inout processor;
    submodules:
        virtual_processor[m]: Virtual_processor {
            @display("p=158,104");
        }
        transaction_dispatcher: Dispatcher { //Simulate the NIC to VirtualProcessors routing
            in_size = m; //Number of gates that look towards VirtualProcessors
            ext_size = n; //Number of gates that look towards Clients
            @display("p=158,34");
        }
        processor_dispatcher: Dispatcher { //Simulate the VirtualProcessor to Processor routing
            in_size = 1; //Number of gates that look towards the Processor
            ext_size = m; //Number of gates that look towards VirtualProcesors
            @display("p=158,177");
        }
    connections:
        for i=0..transaction_dispatcher.ext_size {
            transaction_dispatcher.extern[i] <--> io[i];
        }
        for i=0..transaction_dispatcher.int_size {
            transaction_dispatcher.intern[i] <--> virtual_processor[i].transaction_dispatcher;
        }
        for i=0..processor_dispatcher.ext_size {
            virtual_processor[i].processor_dispatcher <--> processor_dispatcher.extern[i];
        }
        processor_dispatcher.intern[0] <--> processor;

}
