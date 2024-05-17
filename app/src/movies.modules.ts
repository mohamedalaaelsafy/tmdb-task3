import styled from "styled-components";


export const MoviesWrapper = styled.div`
display: flex;
align-items: center;
justify-content: center;
flex-direction: column;
padding: 10px;
box-shadow: 1px 1px 15px 5px grey;
border-radius: 40px;


h1 {
margin-bottom: 3rem;
}


.movieCard {
display: flex;
justify-content: space-evenly;
align-items: flex-start;
flex-wrap: wrap;
margin-top: 5rem;
}


.movie {
display: flex;
flex-direction: column;
align-items: center;
padding: 0;
margin: 10px;
}


.movieImg {
border-radius: 10px;
> img {
box-shadow: 1px 1px 15px 5px grey;
padding: 5px;
border-radius: 30px;
}
}


.movieInfo {
display: flex;
flex-direction: column;
align-items: center;


> h4 {
width: 230px;
text-align: center;
white-space: nowrap;
overflow: hidden;
text-overflow: ellipsis;
margin-bottom: 0;
}


> p {
color: grey;
}
}


.buttons {
margin-top: 3rem;
display: flex;
justify-content: space-evenly;
align-items: center;
width: 100%;
> button {
font-size: 15px;
background: #f76429;
border: none;
outline: none;
color: #fff;
font-size: 18px;
font-weight: 500;
padding: 4px 16px;
border-radius: 5px;
letter-spacing: 1px;
transition: all 0.3s ease-in-out;


&:hover {
background-color: #007bff;
cursor: pointer;
transform: scale(1.1);
}
}
}


.searchBar
{
input, button {
margin: auto;
outline: none;
border:none;
border-radius:20px;
position: absolute;
bottom:75%;
transform: translate(-50%, -50%);
text-align: center;
}
>input {
height: 25px;
width: 25%;
box-shadow: 1px 1px 6px -2px grey;
padding: 10px;
left:50%;
font-size: 22px;
&::placeholder{
font-size: 16px;
}
}


> button {
height: 46px;
padding: 0 25px;
left:60%;
font-size: 15px;
background: linear-gradient(90deg, rgba(15,255, 184,1)33%,
rgba(7,110, 112,1)100%);
cursor: pointer;
font-weight:bolder;
}
}
`;