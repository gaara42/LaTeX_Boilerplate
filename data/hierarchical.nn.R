# Load neural net library
library(nnet)
library(neuralnet)

# Load trained neural nets
source("model.training.NN.hierarchical.v1")
trainedNeuralNets = NNtrained()

# Load data
source("data.run.NN.hierarchical")
this.data = NNdata()

# define the number of loops before an error has occured
error.loop.value = 3

neuralNet <- function(neuralNetFxn, this.loop.input){
	# this function runs specific level of a hierarchal neural network then recursively calls the next layer
	# base case is defined when a parent neural net has no children

	# run the initial neural net on the input
	# classifications is a tuple of probabilities for being in given class
	list(classifications,subfunctions) := neuralNetFxn(this.loop.input)


	# set the threshold 
	threshold = this.loop.threshold.value

	# get index of next neural net function to be called
	subidx = max(find.col(classifications>threshold))

	# each neural net function outputs a list of functions that can further be called
	subfunctions = [...
	fearNN(),
	runNN(),
	thinkNN(),
	...]
	# 
	next.NN.fxn = subfunctions[[subidx]]

	# base case, if no more children, exit loop, else 
	# recursively call the next neural network
	if(next.NN.fxn(children=TRUE)){
		return(classifications,next.NN.fxn)
	}else if(){		
		neuralNet(next.NN.fxn,this.loop.input)
	}
}

main <- function(inputData,trainedNeuralNets,run.count){
	# get root neural net by passing no argument to trained neural nets
	root.NN = trainedNeuralNets()

	# Run the neural net hierarchical function until reach end node
	list(classification, id.NN) := neuralNet(root.NN,inputData)

	# Check that we have reached a neural net without children, else call main() again
	if(id.NN(children=TRUE)&run.count<error.loop.value){
		main(inputData,trainedNeuralNets,run.count+1)
	}else if(){
		return(NULL)
	}

	# Let user know choice
	print(classification)

	# Return classification, used later if integrated into system
	return(list(classification,id.NN))
}

# start the program
main(this.data,trainedNeuralNets,run.count=0)