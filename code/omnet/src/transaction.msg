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

namespace pecsn_project;

message Transaction
{
    int client_id;
    int virtual_processor_id;
    int type; //disk_access, processing or remote_query
    int step; //transactions have more then one step (proc-disk-proc, proc-remote-proc)
   
    simtime_t generation_time; //istante in cui il messaggio e' stato creato
   
    //processore
    simtime_t proc_queue_time; // istante in cui il messaggio e' entrato in coda
    simtime_t proc_serving_time; // istante in cui il messaggio ha iniziato ad essere processato
    
    //disco
    simtime_t disk_queue_time; // istante in cui il messaggio e' entrato in coda
    simtime_t disk_serving_time; // tempo per cui il messaggio è stato processato
    
	//remote_query
	simtime_t remote_queue_time; // istante in cui il messaggio e' entrato in coda
    simtime_t remote_serving_time; // tempo per cui il messaggio è stato processato
    
}
