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

#include "disk.h"
#include "transaction_m.h"

namespace pecsn_project {

Define_Module(Disk);

void Disk::initialize()
{
   if(!this->queue->isEmpty()) this->queue->clear();
   this->working = false;
}

void Disk::handleMessage(cMessage *msg)
{
    if(msg->isSelfMessage())
        handleSelfMessage(msg);
    else
        handleProcessorMessage(msg);
}

void Disk::handleProcessorMessage(cMessage* msg)
{
    EV<<"[handleProcessorMessage]: "<< msg->getFullName()<<"working: "<<this->working<<endl;
    if(this->working){
        this->queue->insert(msg);
    }
    else{
        scheduleAt(simTime() + exponential(par("serviceTimeMean").doubleValue()), msg);
        this->working = true;
    }

}

void Disk::handleSelfMessage(cMessage *msg){
            send(msg, "out"); //Send message to processor

            if(!queue->isEmpty()){
                cMessage * self = check_and_cast<cMessage *>(queue->pop());

                scheduleAt(simTime() + exponential(par("serviceTimeMean").doubleValue()), self);
                working = true;
            }
            else
                working = false;

}

} //namespace
