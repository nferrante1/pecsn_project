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

#include "processor.h"
#include "transaction_m.h"


namespace pecsn_project {

Define_Module(Processor);

void Processor::initialize()
{
    completeSignal = registerSignal("complete");
    if(!queue->isEmpty())
        queue->clear();
    working = false;
    completedTransactions = 0;
//    emit(completeSignal, 0);
}

void Processor::handleMessage(cMessage *msg)
{
    if(msg->isSelfMessage())
        handleSelfMessage(msg);
    else{
        handleRemoteMessage(msg);
    }
}

void Processor::handleSelfMessage(cMessage *msg)
{
    try {
        Transaction *transaction = check_and_cast<Transaction*>(msg);
        Action action = evaluateAction();
        EV_INFO<<"Action : "<<action<<endl;
        switch (action) {
        case TERMINATE:
            EV_INFO<<"Sending response to client at "<<transaction->getGate()<<endl;

            transaction->setName("RESPONSE");

            //completeSignal = registerSignal("complete");
            completedTransactions++;
            emit(completeSignal, completedTransactions);
            send(transaction, "out", transaction->getGate());

            break;
        case DISK:
            EV << "Sending transaction to disk" << endl;

            transaction->setName("DISK");
            send(msg, "out", 0); // 0 is the index of the disk's gate
            break;
        case REMOTE_QUERY:
            EV << "Sending transaction to remote server" << endl;

            transaction->setName("REMOTE");
            send(msg, "out", 1); // 1 is the index of the remote server's gate
            break;
        default:
            EV << "Unsupported Operation " << endl;
            break;
        }

        beep_ = nullptr;


    //Get the next queued transaction

    if (!queue->isEmpty()) {
        beep_ = check_and_cast<cMessage *>(queue->pop());

        double working_time = exponential(par("serviceTimeMean").doubleValue());

        EV << " - working time: " << working_time;

        scheduleAt(simTime() + working_time, beep_);
        working = true;
    } else
        working = false;
    } catch (cRuntimeError *error) {
        EV <<error->getFormattedMessage();
    }
}

void Processor::handleRemoteMessage(cMessage *msg) {

    try {
        Transaction *transaction = check_and_cast<Transaction*>(msg);
        const char* request= "REQUEST";
        if(strncmp(transaction->getFullName(), request, strlen(transaction->getFullName())) == 0){
            EV << "Client Request arrived";
            transaction->setGate(transaction->getArrivalGate()->getIndex());
        }

        if (!working) {

            EV << "Working" << endl;

            double working_time = exponential(
                    par("serviceTimeMean").doubleValue());

            EV << "Preprocessing time: " << working_time << endl;
            scheduleAt(simTime() + working_time, transaction);
            working = true;
        } else {
            EV << "Added to queue" << endl;
            queue->insert(transaction); //Message added to the queue
        }
    } catch (cRuntimeError *error) {
        EV << "Error: "<< error->getFormattedMessage() << endl;
        return;
    }

}

Action Processor::evaluateAction(){
         double random = uniform(0, 1);

         EV << "[evaluateAction] -- Random number generated: " << random;

         double p1 = getParentModule()->par("p1").doubleValue();
         double p2 = getParentModule()->par("p2").doubleValue();
         EV<<"P1 = "<<p1<<" P2: "<<p2<<endl;
         if(random < p1)
             return TERMINATE;
         else if(random < p1 + p2)
             return DISK;
         else
             return REMOTE_QUERY;
}


Processor::~Processor(){
    if(beep_ != nullptr)
        cancelAndDelete(beep_);
    if(!queue->isEmpty()){
        queue->clear();
    }
    delete queue;
}

} //namespace
